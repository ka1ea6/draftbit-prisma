import "dotenv/config";
import { Client } from "pg";
import express from "express";
import cors from "cors";
import connect from "./db";
import mainRouter from "./routes";

// Add your routes here
const setupApp = (client: Client): express.Application => {
  const app: express.Application = express();
  // TODO: apply correct cors origin
  app.use(cors({ origin: "*" }));

  app.use(express.json());
  app.use("/", mainRouter);
  return app;
};

// Waits for the database to start and connects

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
