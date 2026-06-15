@echo off
chcp 65001 >nul
cd /d "%~dp0"
title QRCode Pro

echo.
echo  ====================================
echo    QRCode Pro - ishga tushirilmoqda
echo  ====================================
echo.

REM Docker ishlayaptimi tekshirish
docker info >nul 2>&1
if errorlevel 1 (
    echo  [XATO] Docker ishlamayapti.
    echo  Docker Desktop ni oching va biroz kuting, keyin qayta urinib koring.
    echo.
    pause
    exit /b 1
)

REM .env yoq bolsa namunadan nusxa olish
if not exist ".env" (
    if exist ".env.example" (
        copy ".env.example" ".env" >nul
        echo  [OK] .env yaratildi
    )
)

echo  [..] Konteynerlar kotarilmoqda...
docker compose up -d
if errorlevel 1 (
    echo.
    echo  [XATO] Ishga tushmadi. Loglarni koring: docker compose logs
    echo.
    pause
    exit /b 1
)

echo.
echo  [OK] Tayyor!
echo.
echo    Ilova:  http://localhost:5000
echo    Login:  admin / admin123
echo    MySQL:  localhost:3308
echo.

REM Brauzerda avtomatik ochish
start "" http://localhost:5000

echo  Toxtatish uchun: stop.cmd
echo.
pause
