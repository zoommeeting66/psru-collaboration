@echo off
setlocal
cd /d "%~dp0"
echo ===============================================
echo   Reset PSRU PostgreSQL Database
echo ===============================================
echo.
echo This removes ALL data in the local PSRU PostgreSQL container.
echo Use this only for first-time setup or when the database password is incorrect.
choice /C YN /M "Delete the local PSRU database and create a new one"
if errorlevel 2 exit /b 0

docker compose down -v
if errorlevel 1 goto failed
docker compose up -d
if errorlevel 1 goto failed

echo Waiting for PostgreSQL...
set /a attempts=0
:wait_for_database
docker compose exec -T db pg_isready -U psru -d psru_collaboration >nul 2>nul
if not errorlevel 1 goto ready
set /a attempts+=1
if %attempts% GEQ 30 goto failed
timeout /t 1 /nobreak >nul
goto wait_for_database

:ready
npm.cmd run db:migrate
if errorlevel 1 goto failed
npm.cmd run db:seed
if errorlevel 1 goto failed
echo.
echo Database is ready. Run start-app.cmd to open the system.
pause
exit /b 0

:failed
echo Database reset did not complete. Ensure Docker Desktop is running and try again.
pause
exit /b 1
