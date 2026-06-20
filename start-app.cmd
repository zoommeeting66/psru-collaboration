@echo off
setlocal
cd /d "%~dp0"

echo Starting PSRU Collaboration System...
if not exist node_modules npm.cmd install
if not exist client\node_modules npm.cmd --prefix client install
if not exist server\node_modules npm.cmd --prefix server install

echo.
echo Open http://localhost:5173 in your browser
echo Press Ctrl+C to stop the system.
npm.cmd run dev
