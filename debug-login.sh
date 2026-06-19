#!/bin/bash
# Login Debugging Script

echo "[INFO] QRCode Pro - Login Debug"
echo "==============================="
echo ""

# Detect Docker Compose command
if command -v docker-compose &> /dev/null; then
    DC="docker-compose"
else
    DC="docker compose"
fi

# Check if containers are running
echo "[INFO] Checking Docker containers..."
$DC ps | grep -E "qrcode-app|qrcode-mysql|qrcode-nginx"
echo ""

# Check environment variables
echo "[INFO] Environment variables in app container:"
$DC exec -T app env | grep -E "ADMIN_|AUTH_SECRET|NEXT_PUBLIC" || echo "[WARNING] No admin variables found"
echo ""

# Check .env file on host
echo "[INFO] Local .env file:"
if [ -f .env ]; then
    grep -E "ADMIN_|AUTH_SECRET|NEXT_PUBLIC" .env || echo "[WARNING] No admin variables in .env"
else
    echo "[ERROR] .env file not found!"
fi
echo ""

# Test API endpoint
echo "[INFO] Testing login API endpoint..."
echo "[INFO] Attempting login with: username=admin, password=qrcode-2026"
echo ""

RESPONSE=$(curl -s -X POST http://172.18.1.3:8090/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"qrcode-2026"}')

echo "[RESPONSE] $RESPONSE"
echo ""

if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo "[OK] Login successful!"
elif echo "$RESPONSE" | grep -q '"error"'; then
    ERROR_MSG=$(echo "$RESPONSE" | grep -o '"error":"[^"]*"' | sed 's/"error":"//' | sed 's/"//')
    echo "[ERROR] Login failed: $ERROR_MSG"
    echo ""
    echo "[HINT] This means credentials don't match:"
    echo "  - Check ADMIN_USERNAME in .env"
    echo "  - Check ADMIN_PASSWORD in .env"
    echo "  - Ensure no extra spaces or quotes"
else
    echo "[ERROR] Unexpected response: $RESPONSE"
    echo ""
    echo "[HINT] Possible issues:"
    echo "  1. App not running or not accessible"
    echo "  2. Network issue (check IP 172.18.1.3:8090)"
    echo "  3. API endpoint changed"
fi

echo ""
echo "[INFO] Quick fixes:"
echo "  1. Restart containers: $DC restart"
echo "  2. View app logs: $DC logs -f app"
echo "  3. Check MySQL: $DC logs mysql"
echo "  4. Reset all: $DC down -v && $DC up -d"
