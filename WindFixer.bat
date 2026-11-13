@echo off
setlocal EnableExtensions
title Windscribe Bypass - WindFixer
color 0B

REM ============================================================
REM  WindFixer.bat
REM  Deletes the 2 leftover Windscribe registry keys shown in
REM  the video (Arka Labs - Windscribe free VPN trick):
REM
REM    1) HKCU\Software\Microsoft\Windows\CurrentVersion\NetControlPort
REM    2) HKCU\Software\Windscribe\Windscribe2
REM
REM  Core commands are exactly the ones from the video:
REM    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\NetControlPort" /f
REM    reg delete "HKCU\Software\Windscribe\Windscribe2" /f
REM ============================================================

REM --- Run as administrator (auto-elevate) ---
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ============================================================
echo   Windscribe Bypass - WindFixer
echo ============================================================
echo.
echo   BEFORE YOU CONTINUE :
echo     1) Log Out of your current Windscribe account.
echo     2) This file will then close Windscribe completely.
echo.
echo   Note: Approve the UAC prompt with the SAME Windows user
echo   that uses Windscribe, otherwise HKCU points elsewhere.
echo.
pause
echo.

echo [1/2] Closing Windscribe...
taskkill /F /IM "Windscribe.exe" >nul 2>&1
taskkill /F /IM "WindscribeLauncher.exe" >nul 2>&1
taskkill /F /IM "WindscribeService.exe" >nul 2>&1
timeout /t 1 /nobreak >nul
echo       Done.
echo.

echo [2/2] Deleting the registry keys...
echo.
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\NetControlPort" /f
if %errorlevel%==0 (
    echo [OK] NetControlPort deleted.
) else (
    echo [NOT FOUND] NetControlPort was not there - already clean.
    echo             This is normal.
)
echo.
reg delete "HKCU\Software\Windscribe\Windscribe2" /f
if %errorlevel%==0 (
    echo [OK] Windscribe2 deleted.
) else (
    echo [NOT FOUND] Windscribe2 was not there - already clean.
)
echo.
echo ============================================================
echo   DONE. Now open Windscribe and create the new account.
echo ============================================================
echo.
pause
endlocal
exit /b 0