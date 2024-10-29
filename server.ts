import "dotenv/config";
import { Client } from "pg";
import express from "express";
import waitOn from "wait-on";
import onExit from "signal-exit";
import cors from "cors";
import { insertIntoTable } from "./db-helpers";
import { mapDimensions } from "./utils";

// Add your routes here
const setupApp = (client: Client): express.Application => {
  const app: express.Application = express();
  // TODO: apply correct cors origin
  app.use(cors({ origin: "*" }));

  app.use(express.json());

  app.post("/items", async (req, res) => {
    console.log(req.body);
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
    try {
      const itemId = req.params.itemId;
      if (!itemId || isNaN(parseInt(itemId)))
        return res.status(400).json({
          status: 400,
          ok: false,
          statusText: "failure",
          message: "invalid item id",
        });

      const { rowCount } = await client.query(
        `SELECT id FROM items WHERE id=$1`,
        [parseInt(req.params.itemId)]
      );

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
    } catch (err) {
      await client.query("ROLLBACK");
    }
  });

  app.post("/dimensions", async (req, res) => {
    const unit = req.body.unit;

    const { rows } = await client.query(`SELECT * FROM units WHERE name = $1`, [
      unit,
    ]);
    console.log("rows", rows);
    res.end();
  });

  return app;
};

// Waits for the database to start and connects
const connect = async (): Promise<Client> => {
  console.log("Connecting");
  const resource = `tcp:${process.env.PGHOST}:${process.env.PGPORT}`;
  console.log(`Waiting for ${resource}`);
  await waitOn({ resources: [resource] });
  console.log("Initializing client");
  const client = new Client();
  await client.connect();
  console.log("Connected to database");

  // Ensure the client disconnects on exit
  onExit(async () => {
    console.log("onExit: closing client");
    await client.end();
  });

  return client;
};

const main = async () => {
  const client = await connect();
  const app = setupApp(client);
  const port = parseInt(process.env.SERVER_PORT!);
  app.listen(port, () => {
    console.log(
      `Draftbit Coding Challenge is running at http://localhost:${port}/`
    );
  });
};

main();
