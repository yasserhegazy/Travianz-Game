@echo off
setlocal enabledelayedexpansion
title TravianZ - One Click Starter
color 0A

echo.
echo  ========================================
echo     TravianZ - One Click Starter
echo  ========================================
echo.
echo  This script will start XAMPP and open the game for you.
echo.

REM =============================================
REM            FIX INSTALL FOLDER
REM =============================================
:FIX_INSTALL
set "TARGET=%~1"
if "%TARGET%"=="" goto :MAIN
if not exist "%TARGET%install" (
    for /d %%D in ("%TARGET%installed_*") do (
        echo  [FIX] Renaming %%~nxD back to install...
        ren "%%D" install
        goto :fix_flag
    )
)
:fix_flag
if exist "%TARGET%var\installed" (
    echo  [FIX] Removing old installed flag...
    del /F /Q "%TARGET%var\installed" >nul 2>&1
)
exit /b

REM =============================================
REM              MAIN ENTRY
REM =============================================
:MAIN

REM Find XAMPP - check multiple locations
set "XAMPP_PATH="
for %%P in (C:\xampp D:\xampp E:\xampp) do (
    if exist "%%P\htdocs" (
        set "XAMPP_PATH=%%P"
        goto :xampp_found
    )
)
echo  [ERROR] XAMPP not found!
echo  Download: https://www.apachefriends.org
start https://www.apachefriends.org/download.html
pause
exit /b

:xampp_found
echo  [OK] Found XAMPP at: %XAMPP_PATH%

REM Check if XAMPP is fully installed
set "XAMPP_FULL=0"
if exist "%XAMPP_PATH%\xampp-control.exe" set "XAMPP_FULL=1"
if exist "%XAMPP_PATH%\apache_start.bat" set "XAMPP_FULL=1"

if "%XAMPP_FULL%"=="0" (
    echo.
    echo  [WARNING] XAMPP folder exists but is not fully installed.
    echo  Only htdocs folder was found. You need to install XAMPP
    echo  properly to get Apache and MySQL.
    echo.
    echo  Opening download page...
    start https://www.apachefriends.org/download.html
    echo.
    echo  IMPORTANT: When installing, choose the SAME folder: %XAMPP_PATH%
    echo  The installer will add Apache, MySQL, PHP etc alongside htdocs.
    echo  Then run this bat file again.
    echo.
    pause
    exit /b
)

REM Fix install folder in source
call :FIX_INSTALL "%~dp0"

REM Copy project to htdocs
set "DEST=%XAMPP_PATH%\htdocs\travian"
if not exist "%DEST%\index.php" (
    echo  [COPY] Copying to htdocs\travian...
    xcopy "%~dp0*" "%DEST%\" /E /I /Y /Q >nul 2>&1
    echo  [OK] Done!
) else (
    echo  [OK] Project already in htdocs\travian.
    call :FIX_INSTALL "%DEST%\"
    xcopy "%~dp0*" "%DEST%\" /E /I /Y /Q /D >nul 2>&1
)

REM ---- APACHE ----
echo  [START] Apache...
set "XAMPP_PORT=80"
set "XAMPP_URL_PORT="

tasklist /FI "IMAGENAME eq httpd.exe" 2>NUL | find /I "httpd.exe" >NUL
if %errorlevel% equ 0 (
    echo  [OK] Apache already running ^(started from XAMPP Control Panel^).
    goto :apache_detect_port
)
goto :apache_start

:apache_detect_port
REM Read Apache port from httpd.conf (most reliable)
if exist "%XAMPP_PATH%\apache\conf\httpd.conf" (
    for /f "tokens=*" %%a in ('powershell -NoProfile -Command "foreach($l in (Get-Content '%XAMPP_PATH%\apache\conf\httpd.conf')){if($l -match '^Listen\s+(?:.*:)?(\d+)'){$matches[1]; break}}" 2^>nul') do set "XAMPP_PORT=%%a"
)
if "%XAMPP_PORT%"=="" set "XAMPP_PORT=80"
if not "%XAMPP_PORT%"=="80" set "XAMPP_URL_PORT=:%XAMPP_PORT%"
echo  [OK] Apache is on port %XAMPP_PORT%.
goto :apache_done

:apache_start
REM Apache is NOT running - we need to start it ourselves
REM Always restore httpd.conf to port 80 first (undo any previous patches)
if exist "%XAMPP_PATH%\apache\conf\httpd.conf" (
    powershell -Command "(Get-Content '%XAMPP_PATH%\apache\conf\httpd.conf') -replace 'Listen \d+$','Listen 80' -replace 'ServerName localhost:\d+','ServerName localhost:80' | Set-Content '%XAMPP_PATH%\apache\conf\httpd.conf'"
)

REM Check if port 80 is free
powershell -Command "if((netstat -ano | Select-String 'LISTENING' | Select-String ':80\s').Count -gt 0){exit 1}else{exit 0}" >nul 2>&1
if %errorlevel% equ 1 (
    echo  [WARNING] Port 80 is blocked by another program.
    echo  [FIX] Switching Apache to port 8080...
    set "XAMPP_PORT=8080"
    set "XAMPP_URL_PORT=:8080"
    if exist "%XAMPP_PATH%\apache\conf\httpd.conf" (
        powershell -Command "(Get-Content '%XAMPP_PATH%\apache\conf\httpd.conf') -replace 'Listen 80$','Listen 8080' -replace 'ServerName localhost:80$','ServerName localhost:8080' | Set-Content '%XAMPP_PATH%\apache\conf\httpd.conf'"
        echo  [OK] Apache config set to port 8080.
    )
)

echo Start-Process -FilePath '%XAMPP_PATH%\apache\bin\httpd.exe' -WindowStyle Hidden > "%TEMP%\start_apache.ps1"
powershell -ExecutionPolicy Bypass -File "%TEMP%\start_apache.ps1"
del "%TEMP%\start_apache.ps1" >nul 2>&1
timeout /t 3 /nobreak >nul

tasklist /FI "IMAGENAME eq httpd.exe" 2>NUL | find /I "httpd.exe" >NUL
if %errorlevel% equ 0 goto :apache_done
echo  [ERROR] Apache failed to start!
echo  Try: Run this bat file as Administrator.
pause
exit /b

:apache_done
echo  [OK] Apache running on port %XAMPP_PORT%!

REM ---- MYSQL ----
set "XAMPP_DB_PORT=3306"

echo  [START] MySQL...

REM Check if ANY mysqld.exe is running (ExecutablePath can be null for service/panel-started processes)
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I "mysqld.exe" >NUL
if %errorlevel% equ 0 (
    echo  [OK] MySQL is already running.

    REM Detect actual listening port from network connections (most reliable)
    for /f "tokens=*" %%a in ('powershell -NoProfile -Command "$p=Get-CimInstance Win32_Process -Filter 'Name=''mysqld.exe''' -EA SilentlyContinue|Select -First 1 -Expand ProcessId; if($p){(Get-NetTCPConnection -OwningProcess $p -State Listen -EA SilentlyContinue|Select -First 1).LocalPort}" 2^>nul') do (
        if not "%%a"=="" set "XAMPP_DB_PORT=%%a"
    )
    echo  [OK] MySQL is on port %XAMPP_DB_PORT%.
    goto :mysql_done
)

REM XAMPP MySQL is NOT running - start it
REM Restore my.ini to port 3306 first
if exist "%XAMPP_PATH%\mysql\bin\my.ini" (
    powershell -Command "(Get-Content '%XAMPP_PATH%\mysql\bin\my.ini') -replace '^\s*port\s*=.*','port=3306' | Set-Content '%XAMPP_PATH%\mysql\bin\my.ini'"
)

REM Check if 3306 is blocked by another program (like Docker or standalone MySQL)
powershell -Command "if((netstat -ano | Select-String 'LISTENING' | Select-String ':3306\s').Count -gt 0){exit 1}else{exit 0}" >nul 2>&1
if %errorlevel% equ 1 (
    echo  [WARNING] Port 3306 is blocked ^(Another MySQL server is running?^)
    echo  [FIX] Switching XAMPP MySQL to port 3307...
    set "XAMPP_DB_PORT=3307"
    if exist "%XAMPP_PATH%\mysql\bin\my.ini" (
        powershell -Command "(Get-Content '%XAMPP_PATH%\mysql\bin\my.ini') -replace '^\s*port\s*=.*','port=3307' | Set-Content '%XAMPP_PATH%\mysql\bin\my.ini'"
        echo  [OK] MySQL config set to port 3307.
    )
)

echo Start-Process -FilePath '%XAMPP_PATH%\mysql\bin\mysqld.exe' -ArgumentList '--defaults-file=%XAMPP_PATH%\mysql\bin\my.ini' -WindowStyle Hidden > "%TEMP%\start_mysql.ps1"
powershell -ExecutionPolicy Bypass -File "%TEMP%\start_mysql.ps1"
del "%TEMP%\start_mysql.ps1" >nul 2>&1
timeout /t 5 /nobreak >nul

tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I "mysqld.exe" >NUL
if %errorlevel% equ 0 goto :mysql_done
echo  [ERROR] MySQL failed to start!
echo  Try: Run this bat file as Administrator.
pause
exit /b

:mysql_done
echo  [OK] MySQL running on port %XAMPP_DB_PORT%!

REM Verify connection actually works
"%XAMPP_PATH%\mysql\bin\mysql.exe" -u root --port=%XAMPP_DB_PORT% -h 127.0.0.1 -e "SELECT 1" >nul 2>&1
if %errorlevel% equ 0 goto :mysql_verified

echo  [WARNING] Cannot connect on port %XAMPP_DB_PORT%, trying fallback ports...
set "XAMPP_DB_PORT=3306"
"%XAMPP_PATH%\mysql\bin\mysql.exe" -u root --port=3306 -h 127.0.0.1 -e "SELECT 1" >nul 2>&1
if %errorlevel% equ 0 goto :mysql_verified

set "XAMPP_DB_PORT=3307"
"%XAMPP_PATH%\mysql\bin\mysql.exe" -u root --port=3307 -h 127.0.0.1 -e "SELECT 1" >nul 2>&1
if %errorlevel% equ 0 goto :mysql_verified

echo  [ERROR] MySQL is running but cannot connect on ports 3306 or 3307!
echo  Check if MySQL requires a password in XAMPP.
pause
exit /b

:mysql_verified
echo  [OK] MySQL connection verified on port %XAMPP_DB_PORT%!

REM ---- AUTOMATICALLY PATCH GAME CONFIG ----
echo  [FIX] Automatically configuring game to use port %XAMPP_DB_PORT%...

REM Write defaults to .env so installer picks them up
echo DB_HOST=127.0.0.1> "%DEST%\.env"
echo DB_PORT=%XAMPP_DB_PORT%>> "%DEST%\.env"
echo MYSQL_USER=root>> "%DEST%\.env"
echo MYSQL_PASSWORD=>> "%DEST%\.env"
echo MYSQL_DATABASE=travian>> "%DEST%\.env"
echo DB_PREFIX=s9099_>> "%DEST%\.env"

REM If config.php already exists (e.g. user ran setup before but port changed), patch it directly
if not exist "%DEST%\GameEngine\config.php" goto skip_patch
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0patch.ps1" "%DEST%\GameEngine\config.php" %XAMPP_DB_PORT% %XAMPP_PORT%
:skip_patch

REM ---- CREATE DATABASE ----
echo  [DB] Creating database 'travian' if not exists...
if exist "%XAMPP_PATH%\mysql\bin\mysql.exe" (
    "%XAMPP_PATH%\mysql\bin\mysql.exe" -u root --port=%XAMPP_DB_PORT% -e "CREATE DATABASE IF NOT EXISTS travian" 2>nul
    if %errorlevel% equ 0 (
        echo  [OK] Database 'travian' ready.
    ) else (
        echo  [WARNING] Could not auto-create database. The installer will handle it.
    )
) else (
    echo  [WARNING] mysql.exe not found. The installer will create the database.
)

echo.
echo  ========================================
echo       SERVER IS RUNNING!
echo  ========================================
echo.
timeout /t 3 /nobreak >nul
start http://localhost%XAMPP_URL_PORT%/travian/install/?s=1

echo  -------------------------------------------
echo   DATABASE SETTINGS (pre-filled in installer):
echo.
echo   SQL Hostname:  127.0.0.1
echo   Port:          %XAMPP_DB_PORT%
echo   Username:      root
echo   Password:      (leave empty)
echo   DB name:       travian
echo   Prefix:        s9099_
echo   Type:          MYSQLi
echo.
echo   ADMIN ACCOUNT:
echo   Name:          admin
echo   Password:      admin123
echo  -------------------------------------------
echo.
echo  Game:        http://localhost%XAMPP_URL_PORT%/travian
echo  phpMyAdmin:  http://localhost%XAMPP_URL_PORT%/phpmyadmin
echo.
echo  Press any key to STOP the server.
pause
taskkill /F /IM httpd.exe >nul 2>&1
taskkill /F /IM mysqld.exe >nul 2>&1
REM Restore httpd.conf if we patched it
if "%XAMPP_PORT%"=="8080" (
    if exist "%XAMPP_PATH%\apache\conf\httpd.conf" (
        powershell -Command "(Get-Content '%XAMPP_PATH%\apache\conf\httpd.conf') -replace 'Listen 8080','Listen 80' -replace 'ServerName localhost:8080','ServerName localhost:80' | Set-Content '%XAMPP_PATH%\apache\conf\httpd.conf'"
    )
)
REM Restore my.ini if we patched it
if "%XAMPP_DB_PORT%"=="3307" (
    if exist "%XAMPP_PATH%\mysql\bin\my.ini" (
        powershell -Command "(Get-Content '%XAMPP_PATH%\mysql\bin\my.ini') -replace 'port=3307','port=3306' | Set-Content '%XAMPP_PATH%\mysql\bin\my.ini'"
    )
)
echo  Stopped. Bye!
timeout /t 2 /nobreak >nul
exit /b
