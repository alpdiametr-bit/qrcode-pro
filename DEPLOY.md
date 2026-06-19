# QRCode Pro - Server Deployment Guide

## Prerequisites
- Docker & Docker Compose installed
- Git installed
- Server with IP 172.18.1.3 or access to desired network

## Deployment Steps

### 1. Clone Repository
```bash
git clone https://github.com/alpdiametr-bit/qrcode-pro.git
cd qrcode-pro
```

### 2. Configure Environment Variables
```bash
cp .env.example .env
```

Edit `.env` and set secure values:
```env
MYSQL_ROOT_PASSWORD=your_secure_password
MYSQL_DATABASE=qrcode_pro_db
ADMIN_USERNAME=admin
ADMIN_PASSWORD=your_secure_admin_password
AUTH_SECRET=your_long_random_secret_key_min_32_chars
NEXT_PUBLIC_APP_URL=http://172.18.1.3:8090
```

### 3. Start Services
```bash
docker-compose up -d
```

This will start:
- **MySQL** on port 3308 (internal 3306)
- **Next.js App** on internal port 5000
- **Nginx** on port **8090** (public)

### 4. Access Application
- **Web UI**: http://172.18.1.3:8090
- **Scanner**: Built-in QR code scanner at `/dashboard`
- **QR Generation**: Automatic QR generation for uploaded content
- **File Uploads**: `http://172.18.1.3:8090/uploads/`
- **QR Images**: `http://172.18.1.3:8090/qr/`

### 5. Database Management
If first run, initialize database:
```bash
docker-compose exec app npx prisma db push
```

View MySQL data:
```bash
docker-compose exec mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} -D ${MYSQL_DATABASE}
```

## Features Enabled

✅ **QR Code Generation** - Automatic QR code creation for links/data
✅ **File Upload** - Upload files with 30MB size limit
✅ **QR Scanner** - Mobile-friendly QR code scanner
✅ **Dashboard** - Admin dashboard for management
✅ **Public Sharing** - Access generated QR codes via `/q/[id]`
✅ **File Caching** - 7-day cache for uploaded files
✅ **Auto Download** - Redirect to file download on QR scan

## Port Mapping

| Service | Internal | External | URL |
|---------|----------|----------|-----|
| MySQL | 3306 | 3308 | - |
| Next.js | 5000 | - | - |
| Nginx | 80 | 8090 | http://172.18.1.3:8090 |

## Volumes

- `mysql_data` - Database storage
- `uploads_data` - User uploaded files
- `qr_data` - Generated QR code images

## Troubleshooting

### Check Service Status
```bash
docker-compose ps
```

### View Logs
```bash
docker-compose logs -f app
docker-compose logs -f nginx
docker-compose logs -f mysql
```

### Restart Services
```bash
docker-compose restart
```

### Stop Services
```bash
docker-compose down
```

## Security Notes

⚠️ **IMPORTANT**: 
- Always set strong `ADMIN_USERNAME` and `ADMIN_PASSWORD`
- Change `AUTH_SECRET` to a secure random value
- Don't commit `.env` file to git
- Use HTTPS in production (add SSL certificate to Nginx)
- Keep Docker images updated

## Performance

- Static files (QR, uploads) served directly by Nginx
- Database queries optimized with Prisma
- Next.js standalone mode for minimal dependencies
- 30MB file upload limit (configurable in Nginx)
- 7-day browser cache for static files

---

**Version**: 1.0.0
**Last Updated**: 2026-06-19
