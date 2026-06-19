#!/bin/bash
# Docker Permission Fix Script

echo "[INFO] Fixing Docker permissions for current user..."
echo ""

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then 
    echo "[ERROR] Don't run this script as root!"
    echo "[INFO] Run: bash docker-fix-permissions.sh (without sudo)"
    exit 1
fi

# Add user to docker group
echo "[INFO] Adding $USER to docker group..."
sudo usermod -aG docker $USER

echo "[OK] Permission fixed!"
echo ""
echo "[WARNING] You MUST logout and login again for changes to take effect"
echo ""
echo "[INFO] Quick logout option:"
echo "  1. Type: exit"
echo "  2. SSH back in"
echo "  3. Run: ./deploy.sh"
echo ""
echo "[INFO] OR use newgrp (don't need to logout):"
echo "  1. Type: newgrp docker"
echo "  2. Run: ./deploy.sh"
