# Docker Installation Guide for Ubuntu

## Prerequisites
- Ubuntu 18.04 or later
- Root or sudo access
- Internet connection

## Quick Installation

### Option 1: Automated Script (Recommended)

```bash
# Clone the repository
git clone https://github.com/alpdiametr-bit/qrcode-pro.git
cd qrcode-pro

# Make script executable
chmod +x install-docker.sh

# Run installation with sudo
sudo bash install-docker.sh
```

The script will:
- Update system packages
- Install Docker Engine and CLI
- Install Docker Compose (both v2 plugin and standalone)
- Start Docker service
- Add your user to docker group
- Verify installation

### Option 2: Manual Installation

```bash
# 1. Update packages
sudo apt-get update && sudo apt-get upgrade -y

# 2. Install dependencies
sudo apt-get install -y curl wget apt-transport-https ca-certificates gnupg lsb-release git

# 3. Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 4. Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Update and install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 6. Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# 7. Add user to docker group (optional - to run without sudo)
sudo usermod -aG docker $USER

# 8. Install Docker Compose standalone (if needed)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Verify Installation

```bash
docker --version
docker compose version
```

Expected output:
```
Docker version 24.x.x, build xxxxx
Docker Compose version 2.x.x
```

## After Installation

1. **Logout and login** for group changes to take effect
   ```bash
   exit  # logout
   # login again
   ```

2. **Clone and deploy the application**
   ```bash
   git clone https://github.com/alpdiametr-bit/qrcode-pro.git
   cd qrcode-pro
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Access the application**
   ```
   http://172.18.1.3:8090
   ```

## Troubleshooting

### Docker command not found
```bash
# Check if Docker is installed
which docker

# Check Docker status
sudo systemctl status docker

# Restart Docker
sudo systemctl restart docker
```

### Permission denied while trying to connect to Docker daemon
```bash
# Solution 1: Use sudo
sudo docker ps

# Solution 2: Add user to docker group (then logout/login)
sudo usermod -aG docker $USER
newgrp docker
```

### Docker Compose v2 vs v1
- **v2 (newer)**: `docker compose` (installed as plugin)
- **v1 (legacy)**: `docker-compose` (standalone command)

Our `deploy.sh` script automatically detects both versions.

## Uninstall Docker (if needed)

```bash
# Remove Docker packages
sudo apt-get remove docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Remove Docker data
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Remove Docker user from group
sudo deluser $USER docker
```

---

**Version**: 1.0.0
**Last Updated**: 2026-06-19
