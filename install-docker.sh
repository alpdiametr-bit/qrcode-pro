#!/bin/bash
# Docker and Docker Compose Installation Script for Ubuntu

set -e

echo "[INFO] Docker & Docker Compose Installation for Ubuntu"
echo "[INFO] =================================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "[ERROR] This script must be run as root"
    echo "[INFO] Run with: sudo bash install-docker.sh"
    exit 1
fi

echo "[INFO] Updating system packages..."
apt-get update
apt-get upgrade -y

echo "[INFO] Installing dependencies..."
apt-get install -y \
    curl \
    wget \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    git

echo "[INFO] Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "[INFO] Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[INFO] Updating package index..."
apt-get update

echo "[INFO] Installing Docker Engine..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "[INFO] Starting Docker service..."
systemctl start docker
systemctl enable docker

echo "[INFO] Adding current user to docker group..."
usermod -aG docker $SUDO_USER

echo "[INFO] Installing Docker Compose (standalone)..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "[OK] Installation complete!"
echo ""
echo "[INFO] Verifying installation:"
docker --version
docker compose version || docker-compose --version
echo ""
echo "[WARNING] You may need to logout and login again for group changes to take effect"
echo "[INFO] Or run: newgrp docker"
echo ""
echo "[INFO] Next steps:"
echo "  1. Logout and login again"
echo "  2. Clone the repository: git clone https://github.com/alpdiametr-bit/qrcode-pro.git"
echo "  3. cd qrcode-pro"
echo "  4. chmod +x deploy.sh"
echo "  5. ./deploy.sh"
