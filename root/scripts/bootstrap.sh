#!/bin/bash

NGINX="/etc/nginx"
OVERRIDE="${SHARED_VOLUME}/server"

CONFIG="nginx.conf"

# Symlink sites directory
if [[ -d "$OVERRIDE/sites" ]]; then
    echo "Creating symlinks to available sites..."

    rm -rf "conf.d"

    ln -s "$OVERRIDE/sites" "conf.d"

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

    sed -i "s|access_log /.*|access_log ${OVERRIDE}/log/nginx/access.log;|" "$OVERRIDE/$CONFIG" || true
    sed -i "s|error_log /.*|error_log ${OVERRIDE}/log/nginx/error.log;|" "$OVERRIDE/$CONFIG" || true

    echo "Symlink created"
fi

# Update the example document root.
if [[ -f "$OVERRIDE/sites/example.test" ]]; then
    LOGS="${SHARED_VOLUME}/server/log/example"

    mkdir -p $LOGS

    if [[ ! -f "${LOGS}/example-site-fix.lock" ]]; then
        echo "Fixing example.test document root..."

        sed -i 's|root .*|root '${SHARED_VOLUME}'/web/example;|' "$OVERRIDE/sites/example.test" || true

        sed -i 's|access_log /.*|access_log '${SHARED_VOLUME}'/server/log/example.test/nginx_access.log;|' "$OVERRIDE/sites/example.test" || true
        sed -i 's|error_log /.*|error_log '${SHARED_VOLUME}'/server/log/example.test/nginx_error.log;|' "$OVERRIDE/sites/example.test" || true

        sed -i 's|ssl_certificate /shared.*|ssl_certificate '${SHARED_VOLUME}'/server/ssl/example/nginx.crt;|' "$OVERRIDE/sites/example.test" || true
        sed -i 's|ssl_certificate_key /shared.*|ssl_certificate_key '${SHARED_VOLUME}'/server/ssl/example/nginx.key;|' "$OVERRIDE/sites/example.test" || true

        echo "Fixed"

        echo "Creating example.test certificates..."

        mkdir $SHARED_VOLUME/server/ssl/example

        /usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=MX/ST=Oaxaca/L=México/O=Global Fintech/OU=IT Department/CN=example.test" -keyout "$SHARED_VOLUME/server/ssl/example/nginx.key" -out "$SHARED_VOLUME/server/ssl/example/nginx.crt"

        touch "${LOGS}/example-site-fix.lock"

        echo "Created lock file to avoid apply fixes to example site on every container start"
    else
        echo "Example site fix done previously."
        echo ""
    fi

fi

/bin/bash /root/scripts/fix-permissions.sh || true

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf