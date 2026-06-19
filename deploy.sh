#!/bin/bash
# QRCode Pro Deployment Script for Linux/Mac/Ubuntu

set -e

# Detect Docker Compose command (v2 uses 'docker compose', v1 uses 'docker-compose')
if command -v docker-compose &> /dev/null; then
    DC="docker-compose"
elif docker compose version &> /dev/null 2>&1; then
    DC="docker compose"
else
    echo "[ERROR] Docker Compose not found!"
    exit 1
fi

echo "[INFO] QRCode Pro - Server Deployment"
echo "[INFO] =================================="

# Check if .env exists
if [ ! -f .env ]; then
    echo "[ERROR] .env file not found!"
    echo "[INFO] Creating .env from .env.example..."
    cp .env.example .env
    echo "[WARNING] Please edit .env with your configuration before running again!"
    echo "[INFO]    - Set ADMIN_USERNAME and ADMIN_PASSWORD"
    echo "[INFO]    - Set MYSQL_ROOT_PASSWORD"
    echo "[INFO]    - Set AUTH_SECRET"
    echo "[INFO]    - Update NEXT_PUBLIC_APP_URL if needed"
    exit 1
fi

echo "[OK] .env file found"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "[ERROR] Docker is not installed!"
    exit 1
fi

echo "[OK] Docker is installed"

# Check Docker Compose
if ! command -v $DC &> /dev/null 2>&1; then
    echo "[ERROR] Docker Compose is not installed!"
    exit 1
fi

echo "[OK] Docker Compose is installed"

# Start services
echo "[INFO] Starting Docker services..."
$DC down 2>/dev/null || true
$DC pull
$DC up -d

echo "[INFO] Waiting for MySQL to be ready (15 seconds)..."
sleep 15

# Initialize database
echo "[INFO] Initializing database..."
$DC exec -T app npx prisma db push --skip-generate 2>/dev/null || echo "[WARNING] Database already initialized"

echo ""
echo "[OK] Deployment complete!"
echo ""
echo "[INFO] Access the application at: http://172.18.1.3:8090"
echo ""
echo "[INFO] Service Status:"
$DC ps
echo ""
echo "[INFO] Useful commands:"
echo "  - View logs: $DC logs -f app"
echo "  - Stop services: $DC down"
echo "  - Restart: $DC restart"
