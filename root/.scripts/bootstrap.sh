#!/bin/bash

NGINX="/etc/nginx"
OVERRIDE="${SHARED_VOLUME}/shared/server"

CONFIG="nginx.conf"

# Symlink sites directory
if [[ -d "$OVERRIDE/sites" ]]; then
    echo "Creating symlinks to available sites..."

    rm -fr "sites-available"
    ln -s "$OVERRIDE/sites" "sites-available"

    rm -fr "sites-enabled"
    ln -s "$OVERRIDE/sites" "sites-enabled"

    echo "Symlinks created"
fi

# Create logs directory
if [[ ! -d "$OVERRIDE/logs" ]]; then
    echo "Creating log dir..."

    mkdir -p "$OVERRIDE/logs"

    echo "Log dir created"
fi

# Symlink config file.
if [[ -f "$OVERRIDE/$CONFIG" ]]; then
    echo "Creating symlinks to custom nginx config file..."

    rm -f "$CONFIG"
    ln -s "$OVERRIDE/$CONFIG" "$CONFIG"

    sed -i 's|access_log /shared.*|access_log '${OVERRIDE}'/logs/access.log;|' "$OVERRIDE/$CONFIG" || true
    sed -i 's|error_log /shared.*|error_log '${OVERRIDE}'/logs/error.log;|' "$OVERRIDE/$CONFIG" || true

    echo "Symlink created"
fi

# Update the example document root.
if [[ -f "$OVERRIDE/sites/example.test" ]]; then
    echo "Fixing example.test document root..."

    sed -i 's|root /shared.*|root '${SHARED_VOLUME}'/shared/web/example.test/www;|' "$OVERRIDE/sites/example.test" || true

    sed -i 's|ssl_certificate /shared.*|ssl_certificate '${SHARED_VOLUME}'/shared/web/example.test/ssl/nginx.crt;|' "$OVERRIDE/sites/example.test" || true
    sed -i 's|ssl_certificate_key /shared.*|ssl_certificate_key '${SHARED_VOLUME}'/shared/web/example.test/ssl/nginx.key;|' "$OVERRIDE/sites/example.test" || true

    echo "Fixed"
fi

/bin/bash /root/.scripts/fix-permissions.sh || true

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf