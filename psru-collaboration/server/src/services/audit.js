import { query } from '../db.js';
export const audit=(userId,action,entity,entityId,detail={})=>query('INSERT INTO workflow_logs(user_id,action,entity,entity_id,detail) VALUES($1,$2,$3,$4,$5)',[userId,action,entity,entityId,JSON.stringify(detail)]);
