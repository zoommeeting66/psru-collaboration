@echo off
setlocal
echo ===============================================
echo   PSRU Collaboration System - WSL Setup
echo ===============================================
echo.
echo This will ask Windows for administrator permission to install WSL.
echo Your computer must restart after the installation finishes.
choice /C YN /M "Install Windows Subsystem for Linux now"
if errorlevel 2 exit /b 0

powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command wsl --install'"
echo.
echo Complete the installation in the Administrator PowerShell window.
echo Restart Windows when it finishes, then open Docker Desktop once.
pause
