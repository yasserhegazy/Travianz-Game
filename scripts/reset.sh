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

echo "[3/4] Restoring install folder..."
docker compose exec -u root web bash -c '
  INSTALLED=$(ls /var/www/html/ | grep "^installed_" | head -1)
  if [ -n "$INSTALLED" ]; then
    rm -rf /var/www/html/install
    mv /var/www/html/$INSTALLED /var/www/html/install
    echo "  restored $INSTALLED -> install/"
  elif [ -d /var/www/html/install ]; then
    echo "  install/ already present (nothing to restore)"
  else
    echo "  ERROR: no install/ or installed_* folder found"
    exit 1
  fi
'

echo "[4/4] Setting permissions so the install wizard can clean up itself..."
# Give www-data write access to the web root so PHP can rename install/ when done
docker compose exec -u root web chown www-data /var/www/html
# Pre-set GameEngine permissions (PHP can't chmod files owned by the host user)
docker compose exec -u root web chmod -R 755 /var/www/html/GameEngine
docker compose exec -u root web chmod -R 777 /var/www/html/GameEngine/Prevention
docker compose exec -u root web chmod -R 777 /var/www/html/var/log

echo "Ready! Visit /install/ — no commands needed after the wizard finishes."
