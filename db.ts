import { Client } from "pg";
import waitOn from "wait-on";
import onExit from "signal-exit";

let cachedClient: null | Client = null;

const connect = async (): Promise<Client> => {
  if (cachedClient) return cachedClient;

  console.log("Connecting");
  const resource = `tcp:${process.env.PGHOST}:${process.env.PGPORT}`;
  console.log(`Waiting for ${resource}`);
  await waitOn({ resources: [resource] });
  console.log("Initializing client");
  const client = new Client();
  await client.connect();

  cachedClient = client;

  console.log("Connected to database");

  // Ensure the client disconnects on exit
  onExit(async () => {
    console.log("onExit: closing client");
    if (cachedClient) {
      await cachedClient.end();
      cachedClient = null;
    }
  });

  return client;
};

export default connect;
