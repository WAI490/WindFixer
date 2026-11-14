@echo off
setlocal EnableExtensions
title Windscribe Bypass - WindFixer
color 0B
set "VERSION=1.1.0"

REM ============================================================
REM  WindFixer.bat  v%VERSION%
REM
REM  Deletes the 2 leftover Windscribe registry keys shown in
REM  the video (Arka Labs - Windscribe free VPN trick):
REM
REM    1) HKCU\Software\Microsoft\Windows\CurrentVersion\NetControlPort
REM    2) HKCU\Software\Windscribe\Windscribe2
REM
REM  Core commands are exactly the ones from the video:
REM
REM    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\NetControlPort" /f
REM    reg delete "HKCU\Software\Windscribe\Windscribe2" /f
REM
REM  This script does NOT create a backup. If you want one,
REM  export the keys manually first (see README.md).
REM ============================================================

REM --- Run as administrator (auto-elevate) ---
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ============================================================
echo   Windscribe Bypass - WindFixer  v%VERSION%
echo ============================================================
echo.
echo   BEFORE YOU CONTINUE:
echo     1) Log Out of your current Windscribe account.
echo     2) This file will then close Windscribe completely.
echo     3) It will delete the 2 registry keys listed above.
echo        NO backup is created.
echo.
echo   Windows user : %USERNAME%
echo   Profile      : %USERPROFILE%
echo.
echo   IMPORTANT: The user above must be the SAME Windows user
echo   that runs Windscribe. If it is a different admin account,
echo   press N now - otherwise HKCU points to a different
echo   profile and the wrong keys (or none) would be deleted.
echo.
choice /C YN /N /M "Start now? Press Y to continue or N to cancel: "
if errorlevel 2 goto cancelled
echo.

echo [1/2] Closing Windscribe...
taskkill /F /IM "Windscribe.exe" >nul 2>&1
taskkill /F /IM "WindscribeLauncher.exe" >nul 2>&1
taskkill /F /IM "WindscribeService.exe" >nul 2>&1
timeout /t 3 /nobreak >nul

REM --- Verify Windscribe really closed; one retry, then abort ---
tasklist /FI "IMAGENAME eq Windscribe.exe" 2>nul | find /I "Windscribe.exe" >nul
if not errorlevel 1 (
    echo       Windscribe is still running - trying again...
    taskkill /F /IM "Windscribe.exe" >nul 2>&1
    timeout /t 2 /nobreak >nul
    tasklist /FI "IMAGENAME eq Windscribe.exe" 2>nul | find /I "Windscribe.exe" >nul
    if not errorlevel 1 goto stillrunning
)
echo       Done.
echo.

echo [2/2] Deleting the registry keys...
echo.
set "FAILCOUNT=0"
call :DeleteKey "HKCU\Software\Microsoft\Windows\CurrentVersion\NetControlPort" "NetControlPort"
set "RESULT1=%DELRESULT%"
echo.
call :DeleteKey "HKCU\Software\Windscribe\Windscribe2" "Windscribe2"
set "RESULT2=%DELRESULT%"
echo.
if "%RESULT1%"=="FAILED" set /a FAILCOUNT+=1
if "%RESULT2%"=="FAILED" set /a FAILCOUNT+=1

echo ============================================================
echo   Summary:
echo     NetControlPort : %RESULT1%
echo     Windscribe2    : %RESULT2%
echo ============================================================
echo.
if %FAILCOUNT% gtr 0 (
    echo   FINISHED WITH ERRORS - %FAILCOUNT% key^(s^) could NOT be deleted.
    echo   Nothing above marked FAILED was changed. Close Windscribe
    echo   fully, run this file again, and check the messages above.
    echo.
    pause
    endlocal
    exit /b 1
)
echo   DONE. Now open Windscribe and create the new account.
echo.
pause
endlocal
exit /b 0

:cancelled
echo.
echo ============================================================
echo   CANCELLED. Nothing was changed.
echo ============================================================
echo.
pause
endlocal
exit /b 0

:stillrunning
echo.
echo ============================================================
echo   ABORTED: Windscribe could not be closed, so NO keys
echo   were deleted - a running app can lock or recreate them.
echo   Close Windscribe manually ^(including the tray icon^)
echo   and run this file again.
echo ============================================================
echo.
pause
endlocal
exit /b 1

REM ============================================================
REM  DeleteKey: %~1 = key path, %~2 = display name
REM  Sets DELRESULT to DELETED, NOT FOUND, or FAILED.
REM  A key is only reported DELETED after a re-read proves
REM  it is gone; any other failure is FAILED, never hidden
REM  behind the NOT FOUND message.
REM ============================================================
:DeleteKey
reg query "%~1" >nul 2>&1
if errorlevel 1 (
    echo [NOT FOUND] %~2 was not there - already clean.
    echo             This is normal.
    set "DELRESULT=NOT FOUND"
    exit /b 0
)
reg delete "%~1" /f >nul 2>&1
reg query "%~1" >nul 2>&1
if errorlevel 1 (
    echo [OK] %~2 deleted.
    set "DELRESULT=DELETED"
    exit /b 0
)
echo [FAILED] %~2 could not be deleted.
echo          It may be locked by a running process or
echo          access was denied for this user.
set "DELRESULT=FAILED"
exit /b 0
