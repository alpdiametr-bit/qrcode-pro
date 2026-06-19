# Login 401 Error Troubleshooting

## Problem
```
Failed to load resource: the server responded with a status of 401 (Unauthorized)
```

This means the login credentials are not matching the environment variables.

## Common Causes

### 1. .env File Not Loaded in Docker
The .env file must be passed to Docker Compose.

**Check**: Look at `docker-compose.yml` - it should NOT have `.env_file` directive (credentials are loaded from `.env` automatically).

**Solution**:
```bash
# Restart Docker with fresh environment
docker-compose down
docker-compose up -d
```

### 2. Incorrect Credentials
The login credentials must match exactly (case-sensitive).

**Check your .env file**:
```bash
grep ADMIN_USERNAME .env
grep ADMIN_PASSWORD .env
```

**Default test credentials**:
- Username: `admin`
- Password: `qrcode-2026` (or whatever you set in .env)

### 3. Environment Variables Not Set
The Docker container may not have access to .env variables.

**Check** what's in the running container:
```bash
docker-compose exec app env | grep ADMIN
```

Should show:
```
ADMIN_USERNAME=admin
ADMIN_PASSWORD=qrcode-2026
```

If empty, the .env is not being loaded.

## Debugging Steps

### Step 1: Verify .env Exists
```bash
cat .env | grep ADMIN
```

Output should be:
```
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="qrcode-2026"
```

### Step 2: Check Container Environment
```bash
docker-compose exec app env | grep -E "ADMIN|AUTH_SECRET"
```

Should show the values from your .env file.

### Step 3: Check Application Logs
```bash
docker-compose logs app | tail -20
```

Look for any errors during startup.

### Step 4: Test Login via API
```bash
curl -X POST http://172.18.1.3:8090/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"qrcode-2026"}'
```

Should return:
```json
{"ok": true}
```

If returns `{"error":"Login yoki parol noto'g'ri"}`, credentials don't match.

## Solutions

### Solution 1: Restart Services
```bash
docker-compose down
docker-compose up -d
sleep 15
```

Then try login again.

### Solution 2: Rebuild Container
```bash
docker-compose down
docker-compose up -d --build
sleep 15
```

### Solution 3: Verify Credentials Match
Edit `.env`:
```env
ADMIN_USERNAME=admin
ADMIN_PASSWORD=qrcode-2026
```

Make sure no extra spaces or quotes interfere.

### Solution 4: Use Default Fallback
If environment variables are not loading, temporarily add fallback in `src/lib/auth.ts`:

```typescript
export function checkCredentials(username: string, password: string): boolean {
  const u = process.env.ADMIN_USERNAME || "admin";
  const p = process.env.ADMIN_PASSWORD || "qrcode-2026";
  return username === u && password === p;
}
```

Then rebuild:
```bash
docker-compose up -d --build
```

## Complete Reset

If still not working:
```bash
# Stop and remove everything
docker-compose down -v

# Remove containers and volumes
docker system prune -a --volumes

# Start fresh
docker-compose up -d

# Wait for MySQL and app to be ready
sleep 20

# Initialize database
docker-compose exec app npx prisma db push
```

## Debug: Print Environment Variables

Add temporary logging to see what's happening:

Create a debug script:
```bash
#!/bin/bash
echo "=== Environment Variables ==="
docker-compose exec app env | grep -E "ADMIN|AUTH_SECRET|NODE_ENV"
echo ""
echo "=== Testing Credentials ==="
curl -s -X POST http://172.18.1.3:8090/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"qrcode-2026"}' | jq .
```

Run it:
```bash
chmod +x debug-login.sh
./debug-login.sh
```

---

**Most Common Fix**: `docker-compose down && docker-compose up -d` + wait 15 seconds
