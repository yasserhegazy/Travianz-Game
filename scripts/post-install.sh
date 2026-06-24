#!/bin/bash
# Run from project root after completing the install wizard in the browser.
# Handles rename of install/, var/installed flag, and permissions —
# everything that requires root but can't run from PHP inside the container.
set -e

echo "[1/3] Renaming install folder..."
docker compose exec -u root web bash -c '
  if [ -d /var/www/html/install ]; then
    mv /var/www/html/install /var/www/html/installed_'"$(date +%s)"'
    echo "  install/ renamed"
  else
    echo "  already renamed, skipping"
  fi
'

echo "[2/3] Touching var/installed..."
docker compose exec -u root web touch /var/www/html/var/installed

echo "[3/3] Applying permissions..."
docker compose exec -u root web chmod -R 755 /var/www/html/GameEngine
docker compose exec -u root web chmod -R 777 /var/www/html/GameEngine/Prevention
docker compose exec -u root web chmod -R 777 /var/www/html/var/log

echo "Done! Visit your game homepage."
