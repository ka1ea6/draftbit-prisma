import { Router } from "express";
import { insertIntoTable, updateTable } from "./db-helpers";
import { getChangedDimensions, mapDimensions } from "./utils";
import connect from "./db";

const app = Router();

app.post("/items", async (req, res) => {
  const client = await connect();
  let { name }: { name: string } = req.body;
  if (!name || typeof name !== "string") name = "";

  const {
    rows: [item],
  } = await insertIntoTable({
    client,
    columns: ["name"],
    returning: ["*"],
    tableName: "items",
    values: [name],
  });

  res.status(201).json(item);
});

// get dimensions for a
app.get("/items/:itemId/dimensions", async (req, res) => {
  const client = await connect();
  const itemId = req.params.itemId;
  if (!itemId || isNaN(parseInt(itemId)))
    return res.status(400).json({
      status: 400,
      ok: false,
      statusText: "failure",
      message: "invalid item id",
    });

  const { rowCount } = await client.query(`SELECT id FROM items WHERE id=$1`, [
    parseInt(req.params.itemId),
  ]);

  if (!rowCount || rowCount === 0)
    return res.status(400).json({
      status: 400,
      ok: false,
      statusText: "failure",
      message: "invalid item id",
    });

  // checking to see if there is already a dimensions entry for that item
  const {
    rows: [dimensions],
  } = await client.query(
    `
      SELECT * FROM dimensions WHERE item_id=$1
      `,
    [itemId]
  );

  if (dimensions) return res.status(200).json(mapDimensions(dimensions));

  const {
    rows: [newDimensions],
  } = await insertIntoTable({
    client,
    tableName: "dimensions",
    columns: [
      "padding_top",
      "padding_top_unit",
      "padding_right",
      "padding_right_unit",
      "padding_bottom",
      "padding_bottom_unit",
      "padding_left",
      "padding_left_unit",
      "margin_top",
      "margin_top_unit",
      "margin_right",
      "margin_right_unit",
      "margin_bottom",
      "margin_bottom_unit",
      "margin_left",
      "margin_left_unit",
      "item_id",
    ],
    values: [
      "0",
      "px",
      "0",
      "px",
      "0",
      "px",
      "0",
      "px",
      "0",
      "px",
      "0",
      "px",
      "0",
      "px",
      "0",
      "px",
      itemId,
    ],
    returning: ["*"],
  });

  return res.status(201).json(mapDimensions(newDimensions));
});

app.patch("/items/:itemId/dimensions", async (req, res) => {
  const client = await connect();

  const itemId = req.params.itemId;
  if (!itemId || isNaN(parseInt(itemId)))
    return res.status(400).json({
      status: 400,
      ok: false,
      statusText: "failure",
      message: "invalid item id",
    });

  const changed = getChangedDimensions(req.body);

  const {
    rows: [item],
  } = await updateTable({
    client,
    columns: ["name"],
    returning: ["*"],
    tableName: "dimensions",
    values: changed,
  });

  return res.status(200).json(JSON.stringify(item));
});

export default app;
