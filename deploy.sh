#!/bin/bash
# QRCode Pro Deployment Script for Linux/Mac

set -e

echo "📦 QRCode Pro - Server Deployment"
echo "=================================="

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ .env file not found!"
    echo "📋 Creating .env from .env.example..."
    cp .env.example .env
    echo "⚠️  Please edit .env with your configuration before running again!"
    echo "   - Set ADMIN_USERNAME and ADMIN_PASSWORD"
    echo "   - Set MYSQL_ROOT_PASSWORD"
    echo "   - Set AUTH_SECRET"
    echo "   - Update NEXT_PUBLIC_APP_URL if needed (currently: http://172.18.1.3:8090)"
    exit 1
fi

echo "✅ .env file found"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    exit 1
fi

echo "✅ Docker is installed"

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed!"
    exit 1
fi

echo "✅ Docker Compose is installed"

# Start services
echo "🚀 Starting Docker services..."
docker-compose down 2>/dev/null || true
docker-compose pull
docker-compose up -d

echo "⏳ Waiting for MySQL to be ready..."
sleep 10

# Initialize database
echo "🗄️  Initializing database..."
docker-compose exec -T app npx prisma db push --skip-generate

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📍 Access the application at: http://172.18.1.3:8090"
echo ""
echo "📊 Service Status:"
docker-compose ps
echo ""
echo "💡 Useful commands:"
echo "  - View logs: docker-compose logs -f app"
echo "  - Stop services: docker-compose down"
echo "  - Restart: docker-compose restart"
