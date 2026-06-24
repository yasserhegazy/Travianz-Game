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
# Remove whatever is there and restore clean from git
docker compose exec -u root web rm -rf /var/www/html/install
git checkout -- install/

echo "[4/4] Applying GameEngine permissions..."
# Restore ownership to host user so git pull always works
HOST_UID=$(id -u)
docker compose exec -u root web chown $HOST_UID /var/www/html/GameEngine
docker compose exec -u root web chmod -R 755 /var/www/html/GameEngine
docker compose exec -u root web chmod -R 777 /var/www/html/GameEngine/Prevention
docker compose exec -u root web chmod -R 777 /var/www/html/var/log

echo "Ready! Visit /install/ — wizard will finish cleanly on its own."
