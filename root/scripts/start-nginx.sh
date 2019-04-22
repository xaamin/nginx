#!/bin/bash

# Create the user
/bin/bash /root/scripts/create-user.sh

USER=${USER:-xaamin}
SERVER_PATH=${SHARED_VOLUME:-"/home/$USER"}

# Configure and run nginx
NGINX="/etc/nginx"
OVERRIDE="${SHARED_VOLUME}/server"

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

LOCK_FILE="${SHARED_VOLUME}/server/log/rocket.test/rocket.test.lock"

if [ ! -f "$LOCK_FILE" ]; then
    # Update the example document root.
    if [[ -f "$OVERRIDE/sites/rocket.test" ]]; then
        echo "Fixing rocket.test document root..."

        sed -i "s|/shared|$SERVER_PATH|g" "$OVERRIDE/sites/rocket.test"

        touch $LOCK_FILE

        echo "Fixed"
    fi
fi

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf