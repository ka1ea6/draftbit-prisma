import { Client } from "pg";

export const insertIntoTable = async ({
  client,
  tableName,
  columns,
  values,
  returning,
}: {
  client: Client;
  tableName: string;
  columns: string[];
  values: string[];
  returning: string[] | null;
}) => {
  const res = await client.query(
    `
        INSERT INTO ${tableName} (${columns.join(",")}) VALUES (${values
      .map((el, idx) => `$${idx + 1}`)
      .join(",")}) ${returning ? `RETURNING ${returning.join(",")}` : ""};
      `,
    [...values]
  );
  return res;
};
