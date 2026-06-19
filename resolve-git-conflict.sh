#!/bin/bash
# Git conflict resolution script

echo "[INFO] Resolving git conflicts..."
echo ""

# Show current status
echo "[INFO] Current git status:"
git status
echo ""

# Option 1: Keep remote changes (recommended)
echo "[INFO] Option 1: Keep remote changes (recommended for deployment)"
echo "  Command: git checkout --theirs deploy.sh && git add deploy.sh && git commit -m 'Resolve: keep remote deploy.sh'"
echo ""

# Option 2: Keep local changes
echo "[INFO] Option 2: Keep local changes"
echo "  Command: git checkout --ours deploy.sh && git add deploy.sh && git commit -m 'Resolve: keep local deploy.sh'"
echo ""

# Option 3: Abort merge
echo "[INFO] Option 3: Abort merge"
echo "  Command: git merge --abort"
echo ""

read -p "Choose option (1/2/3): " choice

case $choice in
  1)
    echo "[INFO] Keeping remote changes..."
    git checkout --theirs deploy.sh
    git add deploy.sh
    git commit -m "Resolve: keep remote deploy.sh version"
    git push
    echo "[OK] Conflict resolved and pushed!"
    ;;
  2)
    echo "[INFO] Keeping local changes..."
    git checkout --ours deploy.sh
    git add deploy.sh
    git commit -m "Resolve: keep local deploy.sh version"
    git push
    echo "[OK] Conflict resolved and pushed!"
    ;;
  3)
    echo "[INFO] Aborting merge..."
    git merge --abort
    echo "[OK] Merge aborted"
    ;;
  *)
    echo "[ERROR] Invalid choice"
    exit 1
    ;;
esac
