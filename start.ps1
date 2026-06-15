# ============================================
#  QRCode Pro — bitta buyruq bilan ishga tushirish
#  Ishlatish:  .\start.ps1
#  To'xtatish: .\start.ps1 -Down
# ============================================
param(
    [switch]$Down,      # Konteynerlarni to'xtatish
    [switch]$Rebuild,   # Imageni qayta build qilib ishga tushirish
    [switch]$Logs       # Loglarni kuzatish
)

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

function Write-Step($msg)  { Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)    { Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Err($msg)   { Write-Host "[XATO] $msg" -ForegroundColor Red }

Write-Host ""
Write-Host "  QRCode Pro " -ForegroundColor White -BackgroundColor DarkBlue
Write-Host ""

# 1) Docker o'rnatilganmi?
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Err "Docker topilmadi. Docker Desktop o'rnatilganligini tekshiring."
    exit 1
}

# 2) Docker engine ishlayaptimi?
docker info *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Err "Docker ishlamayapti. Docker Desktop ni ishga tushiring va biroz kuting."
    exit 1
}
Write-Ok "Docker ishlayapti"

# 3) .env fayli bormi?
if (-not (Test-Path ".env")) {
    if (Test-Path ".env.example") {
        Write-Step ".env topilmadi — .env.example dan nusxa olinmoqda"
        Copy-Item ".env.example" ".env"
        Write-Ok ".env yaratildi (kerak bo'lsa tahrirlang)"
    } else {
        Write-Err ".env va .env.example topilmadi."
        exit 1
    }
}

# --- To'xtatish rejimi ---
if ($Down) {
    Write-Step "Konteynerlar to'xtatilmoqda..."
    docker compose down
    Write-Ok "To'xtatildi"
    exit 0
}

# --- Loglarni kuzatish rejimi ---
if ($Logs) {
    Write-Step "Loglar (chiqish uchun Ctrl+C)..."
    docker compose logs -f
    exit 0
}

# --- Ishga tushirish ---
if ($Rebuild) {
    Write-Step "Image qayta build qilinib, konteynerlar ishga tushirilmoqda..."
    docker compose up -d --build
} else {
    Write-Step "Konteynerlar ishga tushirilmoqda..."
    docker compose up -d
}

if ($LASTEXITCODE -ne 0) {
    Write-Err "Ishga tushirishda xato. 'docker compose logs' ni tekshiring."
    exit 1
}

Start-Sleep -Seconds 2
Write-Host ""
Write-Step "Holat:"
docker compose ps

# App manzilini .env dan o'qish
$appUrl = "http://localhost:5000"
$envLine = Select-String -Path ".env" -Pattern '^NEXT_PUBLIC_APP_URL=' -ErrorAction SilentlyContinue
if ($envLine) {
    $appUrl = ($envLine.Line -replace '^NEXT_PUBLIC_APP_URL=', '').Trim('"').Trim("'")
}

Write-Host ""
Write-Ok "Tayyor!"
Write-Host "  Ilova:     " -NoNewline; Write-Host $appUrl -ForegroundColor Yellow
Write-Host "  Login:     " -NoNewline; Write-Host "admin / admin123" -ForegroundColor Yellow
Write-Host "  MySQL:     " -NoNewline; Write-Host "localhost:3308 (root)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Loglar:    .\start.ps1 -Logs" -ForegroundColor DarkGray
Write-Host "  To'xtatish:.\start.ps1 -Down" -ForegroundColor DarkGray
Write-Host "  Qayta build:.\start.ps1 -Rebuild" -ForegroundColor DarkGray
Write-Host ""
