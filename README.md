# ระบบฐานข้อมูลบันทึกความร่วมมือทางวิชาการ มหาวิทยาลัยราชภัฏพิบูลสงคราม

ระบบสำหรับบันทึก ติดตาม และรายงาน MOU/MOA/LOI/Agreement/โครงการร่วม พร้อม Dashboard ผู้บริหาร การแจ้งเตือนวันหมดอายุ เอกสารแนบ และบันทึกการทำรายการ (audit log)

## ความสามารถหลัก

- เข้าสู่ระบบด้วย JWT และแยกบทบาท `admin`, `officer`, `executive`
- จัดการข้อมูลหน่วยงานภายในและหน่วยงานคู่ความร่วมมือ
- บันทึก/ค้นหา/กรองความร่วมมือ พร้อมหลายหน่วยงานคู่สัญญา
- บันทึกกิจกรรม, แนบ PDF/DOCX/XLSX (ไม่เกิน 10 MB), audit log
- Dashboard สรุปจำนวน สถานะใกล้หมดอายุ และกราฟประเภทเอกสาร
- ส่งออกรายงาน Excel และ PDF

## โครงสร้าง

```
psru-collaboration/
├── client/       # React + Vite + Tailwind + Recharts
├── server/       # Express + PostgreSQL API
│   ├── migrations/
│   ├── seeds/
│   └── src/
└── docker-compose.yml
```

## ติดตั้งและรัน

ต้องมี Node.js 20+ และ PostgreSQL 16+ (แนะนำ Docker Desktop)

**วิธีที่ง่ายที่สุด (Windows):** ดับเบิลคลิกไฟล์ `start-app.cmd` ที่หน้าโฟลเดอร์โครงการ

- หากยังไม่มี Docker Desktop ระบบจะถามยืนยันก่อนติดตั้งด้วย `winget` (ไม่ต้องติดตั้ง PostgreSQL แยก)
- เมื่อ Docker พร้อม ระบบจะสร้าง PostgreSQL container, ติดตั้ง package ที่จำเป็น, migration และ seed ให้อัตโนมัติ
- จากนั้นระบบจะเปิด [http://localhost:5173](http://localhost:5173) ในเบราว์เซอร์

> Docker Desktop อาจขอสิทธิ์ผู้ดูแลระบบ และอาจต้องเริ่มเครื่องใหม่หนึ่งครั้งตามการตั้งค่า WSL ของ Windows

```powershell
npm install
npm run install:all
docker compose up -d
npm run db:migrate
npm run db:seed
npm run dev
```

เปิด `http://localhost:5173` แล้วเข้าสู่ระบบด้วย `admin@psru.ac.th` / `PsrU@123` (ให้เปลี่ยนรหัสผ่านทันทีเมื่อใช้งานจริง)

> ระบบมี `server/.env` สำหรับการพัฒนาในเครื่องแล้ว หากติดตั้ง PostgreSQL เอง ให้แก้ `DATABASE_URL` ให้ตรงกับเครื่องของคุณ ส่วน production ต้องสร้าง `JWT_SECRET` แบบสุ่มและยาวใหม่เสมอ

หากไม่ใช้คำสั่งรวม สามารถรันแยกได้ดังนี้:

```powershell
cd client
npm install
npm run dev
```

## API หลัก

| กลุ่ม | Endpoint |
| --- | --- |
| Authentication | `POST /api/auth/login`, `GET /api/auth/me` |
| Dashboard | `GET /api/dashboard`, `GET /api/dashboard/notifications` |
| ความร่วมมือ | `GET/POST /api/collaborations`, `GET/PUT /api/collaborations/:id` |
| กิจกรรม | `POST /api/collaborations/:id/activities` |
| เอกสาร | `POST/GET /api/documents/:collaborationId` |
| รายงาน | `GET /api/reports/excel`, `GET /api/reports/pdf` |

## ความปลอดภัย

ใช้ bcrypt hashing, JWT middleware, RBAC, express-validator, parameterized PostgreSQL query, Helmet, จำกัด CORS, ตรวจชนิด/ขนาดไฟล์ และ workflow/audit log. ใน production ควรตั้งค่า `JWT_SECRET` แบบสุ่มยาว, ใช้ HTTPS, จำกัด `CLIENT_URL`, เก็บไฟล์บน object storage และตั้ง scheduled job เพื่อสร้างรายการในตาราง `notifications`/ส่งอีเมลก่อนหมดอายุ 90/60/30 วัน
