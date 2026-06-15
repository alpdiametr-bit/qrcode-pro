@echo off
chcp 65001 >nul
cd /d "%~dp0"
title QRCode Pro - toxtatish

echo.
echo  [..] Konteynerlar toxtatilmoqda...
docker compose down

echo.
echo  [OK] Toxtatildi. (Malumotlar saqlanib qoldi)
echo.
pause
