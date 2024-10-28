import "dotenv/config";
import { Client } from "pg";
import { backOff } from "exponential-backoff";
import express from "express";
import waitOn from "wait-on";
import onExit from "signal-exit";
import cors from "cors";

// Add your routes here
const setupApp = (client: Client): express.Application => {
  const app: express.Application = express();
  // TODO: apply correct cors origin
  app.use(cors({ origin: "*" }));

  app.use(express.json());

  app.get("/dimensions", async (_req, res) => {
    const { rows } = await client.query(`SELECT * FROM margin_dimensions`);
    res.json(rows);
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
