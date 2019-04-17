#!/bin/bash

SHARED="$(pwd)/shared"
DOCKER_USER=${DOCKER_USER:-'xaamin'}
SERVER_PATH="/home/$DOCKER_USER"

echo "This removes previous certificates if exists. Do you want to continue. (Y/N)? "

read ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then

    echo "Provide an account name: "

    read ACCOUNT

    if [[ -d "$SHARED/web/$ACCOUNT" ]]; then
        echo "Source files found. Do you want to remove them. (Y/N)? "

        read ANSWER

        if [[ $ANSWER =~ ^[Yy]$ ]]; then
            echo "Removing source files..."

            rm -rf "$SHARED/web/$ACCOUNT"
        fi
    fi

    if [[ ! -d "$SHARED/web/$ACCOUNT" ]]; then
        echo "Creating conf path..."
        mkdir -p "$SHARED/server/conf/$ACCOUNT"

        echo "Creating log path..."
        mkdir -p "$SHARED/server/log/$ACCOUNT"

        echo "Creating account path and site config..."
        mkdir -p "$SHARED/web/$ACCOUNT"

        # Clonse a git repository

        echo "Do you want clone some repository into the site document root. (Y/N)? "

        read ANSWER

        if [[ $ANSWER =~ ^[Yy]$ ]]; then
            echo "Provide the git repository: "

            read REPOSITORY

            git clone $REPOSITORY "$SHARED/web/$ACCOUNT/"

        else
            cp -rf "$SHARED/server/templates/site/www/" "$SHARED/web/$ACCOUNT/"
        fi
    fi

    cp -rf "$SHARED/server/templates/site/conf/" "$SHARED/server/conf/$ACCOUNT/"

    cp -f "$SHARED/server/templates/site.conf" "$SHARED/server/sites/$ACCOUNT"

    # Change rocket.test to right host
    sed -i '' "s|rocket.test|$ACCOUNT|g" "$SHARED/server/sites/$ACCOUNT"

    sed -i '' "s|/shared|$SERVER_PATH|g" "$SHARED/server/sites/$ACCOUNT"

    # Configure Upstream
    echo "Please provide a PHP-FPM linked container. Default $ACCOUNT "

    read UPSTREAM

    if [[ -z $UPSTREAM ]]; then
        UPSTREAM=$ACCOUNT
    fi

    echo "Using $UPSTREAM as upstram"

    sed -i '' "s|fastcgi_pass.*|fastcgi_pass $UPSTREAM:9000;|" "$SHARED/server/sites/$ACCOUNT"

    # Delete SSL directory if dir exist
    if [[ -d "$SHARED/server/ssl/$ACCOUNT" ]]; then
        echo "Removing old SSL path..."
        rm -rf "$SHARED/server/ssl/$ACCOUNT"
    fi

    # Create SSL directory and certificate for securing Nginx
    if [[ ! -d "$SHARED/server/ssl/$ACCOUNT" ]]; then
        echo "Creating SSL dir..."
        mkdir -p "$SHARED/server/ssl/$ACCOUNT"

        echo "Creating $ACCOUNT certificates..."
        /usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$SHARED/server/ssl/$ACCOUNT/nginx.key" -out "$SHARED/server/ssl/$ACCOUNT/nginx.crt"
    fi

    # Create log files
    if [[ ! -d "$SHARED/server/log/$ACCOUNT" ]]; then
        echo "Creating log dir..."
        mkdir -p "$SHARED/server/log/$ACCOUNT"

    fi

    echo ""
    echo "Please restart your nginx container..."

    echo "That's all"
fi