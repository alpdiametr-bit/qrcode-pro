# QRCode Pro Deployment Script for Windows

Write-Host "📦 QRCode Pro - Server Deployment" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Check if .env exists
if (-not (Test-Path ".env")) {
    Write-Host "❌ .env file not found!" -ForegroundColor Red
    Write-Host "📋 Creating .env from .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "⚠️  Please edit .env with your configuration before running again!" -ForegroundColor Yellow
    Write-Host "   - Set ADMIN_USERNAME and ADMIN_PASSWORD" -ForegroundColor Gray
    Write-Host "   - Set MYSQL_ROOT_PASSWORD" -ForegroundColor Gray
    Write-Host "   - Set AUTH_SECRET" -ForegroundColor Gray
    Write-Host "   - Update NEXT_PUBLIC_APP_URL if needed (currently: http://172.18.1.3:8090)" -ForegroundColor Gray
    exit 1
}

Write-Host "✅ .env file found" -ForegroundColor Green

# Check Docker
try {
    docker --version > $null 2>&1
    Write-Host "✅ Docker is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not installed!" -ForegroundColor Red
    exit 1
}

# Check Docker Compose
try {
    docker-compose --version > $null 2>&1
    Write-Host "✅ Docker Compose is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker Compose is not installed!" -ForegroundColor Red
    exit 1
}

# Start services
Write-Host "🚀 Starting Docker services..." -ForegroundColor Cyan
docker-compose down 2>$null
docker-compose pull
docker-compose up -d

Write-Host "⏳ Waiting for MySQL to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Initialize database
Write-Host "🗄️  Initializing database..." -ForegroundColor Cyan
docker-compose exec -T app npx prisma db push --skip-generate

Write-Host ""
Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📍 Access the application at: http://172.18.1.3:8090" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Service Status:" -ForegroundColor Cyan
docker-compose ps
Write-Host ""
Write-Host "💡 Useful commands:" -ForegroundColor Yellow
Write-Host "  - View logs: docker-compose logs -f app" -ForegroundColor Gray
Write-Host "  - Stop services: docker-compose down" -ForegroundColor Gray
Write-Host "  - Restart: docker-compose restart" -ForegroundColor Gray
