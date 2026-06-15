#!/bin/sh
set -e

echo "⏳ MySQL ulanishini kutmoqda..."
# DB tayyor bo'lguncha db push ni qayta urinish
RETRIES=30
until node node_modules/prisma/build/index.js db push --skip-generate >/dev/null 2>&1; do
  RETRIES=$((RETRIES-1))
  if [ "$RETRIES" -le 0 ]; then
    echo "❌ MySQL ga ulanib bo'lmadi"
    break
  fi
  echo "   ...qayta urinish ($RETRIES)"
  sleep 2
done

echo "✅ Schema sinxronlandi. Server ishga tushmoqda (port 5000)..."
exec "$@"
