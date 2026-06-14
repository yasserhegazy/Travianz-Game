#!/bin/bash
# Wipe the game and reset for a fresh reinstall.
# Run from project root: bash scripts/reset.sh
set -e

echo "[1/3] Dropping and recreating database..."
docker compose exec db mariadb -uroot -prootpassword \
  -e "DROP DATABASE IF EXISTS travian; CREATE DATABASE travian CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

echo "[2/3] Removing state files..."
docker compose exec -u root web rm -f \
  /var/www/html/var/installed \
  /var/www/html/GameEngine/config.php

echo "[3/3] Restoring install folder..."
docker compose exec -u root web bash -c '
  INSTALLED=$(ls /var/www/html/ | grep "^installed_" | head -1)
  if [ -n "$INSTALLED" ]; then
    mv /var/www/html/$INSTALLED /var/www/html/install
    echo "  restored $INSTALLED -> install/"
  elif [ -d /var/www/html/install ]; then
    echo "  install/ already present, nothing to restore"
  else
    echo "  ERROR: no install/ or installed_* folder found"
    exit 1
  fi
'

echo "Ready! Visit /install/ to reinstall."
