# Git Conflict Resolution Guide

## Problem
```
error: Your local changes to the following files would be overwritten by merge:
        deploy.sh
Please commit your changes or stash them before you merge.
```

## Quick Fix

Run one of these commands on the Ubuntu server:

### Option 1: Keep Remote Version (Recommended)
```bash
cd ~/qrcode-pro
git checkout --theirs deploy.sh
git add deploy.sh
git commit -m "Resolve: use remote deploy.sh"
git push
```

### Option 2: Keep Local Version
```bash
cd ~/qrcode-pro
git checkout --ours deploy.sh
git add deploy.sh
git commit -m "Resolve: use local deploy.sh"
git push
```

### Option 3: Abort and Try Again
```bash
cd ~/qrcode-pro
git merge --abort
git pull
```

### Option 4: Stash Local Changes
```bash
cd ~/qrcode-pro
git stash
git pull
git push
```

## Explanation

The conflict occurs because:
1. The Ubuntu server cloned the old `deploy.sh`
2. We pushed a new improved version from Windows
3. Local changes on the server conflict with the remote version

**Recommendation**: Use **Option 1** (keep remote) since the updated script has Ubuntu compatibility fixes.

## Using the Helper Script

We've added a script to handle this automatically:

```bash
chmod +x resolve-git-conflict.sh
./resolve-git-conflict.sh
```

This script will:
1. Show current git status
2. Prompt you to choose a resolution method
3. Apply the fix and push automatically

---

**After resolving**, run deployment:
```bash
./deploy.sh
```
