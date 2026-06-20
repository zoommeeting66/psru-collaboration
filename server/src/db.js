import pg from 'pg';
import dotenv from 'dotenv';
dotenv.config();
export const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
  connectionTimeoutMillis: 10000,
  query_timeout: 30000
});
export const query = (text, params) => pool.query(text, params);
