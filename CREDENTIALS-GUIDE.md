# Understanding QRCode Pro Credentials

The application uses **two separate credential systems**:

## 1. MySQL Database Credentials
Used for **database access only** (not for login)

```env
MYSQL_ROOT_PASSWORD=your_secure_mysql_password
MYSQL_DATABASE=qrcode_pro_db
```

- **User**: `root` (always for MySQL)
- **Password**: Set by `MYSQL_ROOT_PASSWORD`
- **Host**: `localhost:3308` (local dev) or `mysql:3306` (Docker)
- **Database**: `qrcode_pro_db`

Example connection string:
```
mysql://root:your_mysql_password@localhost:3308/qrcode_pro_db
```

---

## 2. Application Admin Login Credentials
Used for **web interface login only**

```env
ADMIN_USERNAME=admin
ADMIN_PASSWORD=your_secure_admin_password
```

- **Username**: Can be anything (e.g., `admin`, `operator`, etc.)
- **Password**: Your admin login password
- **Used**: Web UI at http://172.18.1.3:8090

Example login:
- Username: `admin`
- Password: `qrcode-2026`

---

## Example .env Configuration

```env
# ====== MYSQL DATABASE ======
# ONLY for database connection, NOT for web login
MYSQL_ROOT_PASSWORD=secure-mysql-password-123
MYSQL_DATABASE=qrcode_pro_db
DATABASE_URL="mysql://root:secure-mysql-password-123@mysql:3306/qrcode_pro_db"

# ====== WEB APPLICATION LOGIN ======
# ONLY for admin panel login, NOT for database
ADMIN_USERNAME=admin
ADMIN_PASSWORD=secure-web-password-456
AUTH_SECRET=very-long-random-secret-key-min-32-chars

# Application URL
NEXT_PUBLIC_APP_URL=http://172.18.1.3:8090
```

---

## Key Points

✅ **These ARE separate and independent:**
- MySQL root password ≠ Admin login password
- Can use different passwords
- MySQL is internal only, Admin is for web login

❌ **Do NOT confuse them:**
- Don't use MySQL password to login to web UI
- Don't use Admin password to connect to database
- Each has its own purpose

---

## Where Each is Used

### MySQL Credentials
```bash
# Local development
mysql -u root -p -h localhost -P 3308 qrcode_pro_db

# Via Docker
docker-compose exec mysql mysql -u root -p qrcode_pro_db
```

### Admin Credentials
```
Web Interface: http://172.18.1.3:8090
Login with: admin / qrcode-2026
```

---

## Security Tips

1. **Different passwords**: Always use different passwords for MySQL and Admin
   - ✅ MySQL: `mysql-secure-123`
   - ✅ Admin: `admin-secure-456`
   - ❌ Don't use same for both

2. **MySQL password**: Keep it strong but internal
   - Only used in connection string
   - Not accessed by end users
   - Example: `MySQL@2026!SecurePassword`

3. **Admin password**: This is what you use daily
   - Users will type this to login
   - Make it memorable but secure
   - Example: `QR@Admin2026!Secure`

4. **AUTH_SECRET**: For JWT signing only
   - Must be long (32+ characters)
   - Keep it random and secret
   - Never share it

---

## Testing Each

### Test MySQL Connection
```bash
docker-compose exec mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SELECT VERSION();"
```

### Test Admin Login
```bash
curl -X POST http://172.18.1.3:8090/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"qrcode-2026"}'
```

Expected response: `{"ok":true}`

---

**Summary**: Use your MySQL password for database connections, and your Admin password for web UI login. They are completely separate.
