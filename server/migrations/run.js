import fs from 'fs'; import path from 'path'; import {fileURLToPath} from 'url'; import {pool} from '../src/db.js';
const dir=path.dirname(fileURLToPath(import.meta.url));
try { console.log('Connecting to PostgreSQL...'); await pool.query('SELECT 1'); console.log('Creating database tables...'); await pool.query(fs.readFileSync(path.join(dir,'001_initial.sql'),'utf8')); console.log('Migration complete'); } catch (error) { console.error('Migration failed:',error.message); process.exitCode=1; } finally { await pool.end(); }
