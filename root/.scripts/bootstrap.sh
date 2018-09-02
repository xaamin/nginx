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

# Create log directory
if [[ ! -d "$OVERRIDE/log/nginx" ]]; then
    echo "Creating log dir..."

    mkdir -p "$OVERRIDE/log/nginx"

    echo "Log dir created"
fi

# Symlink config file.
if [[ -f "$OVERRIDE/$CONFIG" ]]; then
    echo "Creating symlinks to custom nginx config file..."

    rm -f "$CONFIG"
    ln -s "$OVERRIDE/$CONFIG" "$CONFIG"

    sed -i 's|access_log .*|access_log '${OVERRIDE}'/log/nginx/access.log;|' "$OVERRIDE/$CONFIG" || true
    sed -i 's|error_log .*|error_log '${OVERRIDE}'/log/nginx/error.log;|' "$OVERRIDE/$CONFIG" || true

    echo "Symlink created"
fi

# Update the example document root.
if [[ -f "$OVERRIDE/sites/example.test" ]]; then
    echo "Fixing example.test document root..."

    sed -i 's|root .*|root '${SHARED_VOLUME}'/shared/web/example.test;|' "$OVERRIDE/sites/example.test" || true

    sed -i 's|access_log .*|access_log '${SHARED_VOLUME}'/shared/server/log/example.test/nginx_access.log;|' "$OVERRIDE/sites/example.test" || true
    sed -i 's|error_log .*|error_log '${SHARED_VOLUME}'/shared/server/log/example.test/nginx_error.log;|' "$OVERRIDE/sites/example.test" || true

    sed -i 's|ssl_certificate /shared.*|ssl_certificate '${SHARED_VOLUME}'/shared/server/ssl/example.test/nginx.crt;|' "$OVERRIDE/sites/example.test" || true
    sed -i 's|ssl_certificate_key /shared.*|ssl_certificate_key '${SHARED_VOLUME}'/shared/server/ssl/example.test/nginx.key;|' "$OVERRIDE/sites/example.test" || true

    echo "Fixed"
fi

/bin/bash /root/.scripts/fix-permissions.sh || true

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf