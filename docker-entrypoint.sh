#!/bin/bash
set -e

# Fix permissions for the installation wizard
# The GameEngine and var folders must be writable by the web server
echo "Setting permissions for TravianZ installation..."
chmod -R 777 /var/www/html/GameEngine /var/www/html/var 2>/dev/null || true
chown -R www-data:www-data /var/www/html/GameEngine /var/www/html/var 2>/dev/null || true

# Execute the original CMD
exec "$@"
