import jwt from 'jsonwebtoken';
import { query } from '../db.js';
export const authenticate = async (req,res,next) => { try { const token=req.headers.authorization?.replace('Bearer ',''); if(!token) return res.status(401).json({message:'กรุณาเข้าสู่ระบบ'}); const payload=jwt.verify(token,process.env.JWT_SECRET); const {rows}=await query('SELECT u.id,u.name,u.email,r.name role FROM users u JOIN roles r ON r.id=u.role_id WHERE u.id=$1 AND u.is_active=true',[payload.id]); if(!rows[0]) return res.status(401).json({message:'ไม่พบผู้ใช้งาน'}); req.user=rows[0]; next(); } catch { res.status(401).json({message:'Token ไม่ถูกต้องหรือหมดอายุ'}); } };
export const allow = (...roles) => (req,res,next) => roles.includes(req.user.role) ? next() : res.status(403).json({message:'ไม่มีสิทธิ์ใช้งาน'});
