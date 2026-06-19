# Docker Permission Denied Error - Fix Guide

## Problem
```
unable to get image 'mysql:8.0': permission denied while trying to connect to the docker API
```

This means your user doesn't have permission to access Docker daemon.

## Quick Fixes

### Fix 1: Run with sudo (Temporary, Not Recommended)
```bash
sudo ./deploy.sh
```

**Pros**: Works immediately  
**Cons**: Need sudo for all Docker commands

### Fix 2: Add User to Docker Group (Recommended)
```bash
sudo usermod -aG docker $USER
```

Then **logout and login again** (or use `newgrp docker`):

#### Option A: Logout/Login
```bash
exit
# SSH back in
./deploy.sh
```

#### Option B: Use newgrp (No logout needed)
```bash
newgrp docker
./deploy.sh
```

### Fix 3: Use Helper Script
```bash
chmod +x docker-fix-permissions.sh
bash docker-fix-permissions.sh
```

Then either logout/login or run `newgrp docker`.

## Verification

Check if permissions are fixed:
```bash
groups $USER
```

Should show `docker` in the list.

Test Docker access:
```bash
docker ps
```

Should list containers without asking for password.

## Why This Happens

1. During `install-docker.sh`, we ran `sudo usermod -aG docker $USER`
2. But group changes don't take effect until you logout/login
3. The script can't run `docker` commands without proper group membership

## After Fixing

Run deployment:
```bash
./deploy.sh
```

## Alternative: Always Use Sudo

If you prefer to keep Docker restricted, always use:
```bash
sudo docker-compose up -d
sudo docker-compose exec app npx prisma db push
```

---

**Recommended Solution**: Add user to docker group once, then never use sudo for Docker.
