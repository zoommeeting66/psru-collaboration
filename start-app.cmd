@echo off
setlocal
cd /d "%~dp0"

echo ===============================================
echo   PSRU Collaboration System - Quick Start
echo ===============================================
echo.

where docker >nul 2>nul
if errorlevel 1 goto install_docker
goto check_docker

:install_docker
echo Docker Desktop is required to run the PostgreSQL database.
choice /C YN /M "Install Docker Desktop now"
if errorlevel 2 goto docker_required

where winget >nul 2>nul
if errorlevel 1 goto no_winget
echo.
echo Installing Docker Desktop. Please accept any Windows permission prompt.
winget install -e --id Docker.DockerDesktop --accept-source-agreements --accept-package-agreements
if errorlevel 1 goto docker_install_failed
echo.
echo Docker Desktop was installed. Open Docker Desktop, complete its setup,
echo then run start-app.cmd again.
pause
exit /b 0

:no_winget
echo Winget is not available on this computer.
echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop/
pause
exit /b 1

:docker_install_failed
echo Docker Desktop installation did not complete. Please install it manually from:
echo https://www.docker.com/products/docker-desktop/
pause
exit /b 1

:docker_required
echo Docker Desktop is required. PostgreSQL does not need a separate installation.
pause
exit /b 1

:check_docker
wsl --status >nul 2>nul
if errorlevel 1 goto wsl_required
docker info >nul 2>nul
if errorlevel 1 goto docker_not_running

echo Starting PSRU Collaboration System...
echo Starting PostgreSQL container...
docker compose up -d
if errorlevel 1 goto database_failed

if not exist node_modules npm.cmd install
if not exist client\node_modules npm.cmd --prefix client install
if not exist server\node_modules npm.cmd --prefix server install

echo Preparing database...
npm.cmd run db:migrate
if errorlevel 1 goto database_failed
npm.cmd run db:seed
if errorlevel 1 goto database_failed

echo.
echo The system is ready at http://localhost:5173
echo Press Ctrl+C to stop the system.
start "" "http://localhost:5173"
npm.cmd run dev
exit /b %errorlevel%

:wsl_required
echo Windows Subsystem for Linux (WSL) is not installed.
echo Run setup-wsl.cmd in this folder, restart Windows, then open Docker Desktop.
pause
exit /b 1

:docker_not_running
echo Docker Desktop is installed but is not running.
echo Open Docker Desktop, wait until it says Engine running, then run this file again.
pause
exit /b 1

:database_failed
echo Database preparation failed. Check that Docker Desktop is running, then try again.
pause
exit /b 1
