#!/bin/bash

SHARED="$(pwd)/shared"

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
        echo "Creating account path and site config..."
        mkdir -p "$SHARED/web/$ACCOUNT"

        cp -rf "$SHARED/server/templates/site/." "$SHARED/web/$ACCOUNT/"

        cp -f "$SHARED/server/templates/site.conf" "$SHARED/server/sites/$ACCOUNT"

        sed -i '' 's|root /shared.*|root '${SHARED}'/shared/web/'$ACCOUNT'/www;|' "$SHARED/server/sites/$ACCOUNT" || true
        sed -i '' 's|ssl_certificate /shared.*|ssl_certificate '${SHARED}'/shared/web/'$ACCOUNT'/ssl/nginx.crt;|' "$SHARED/server/sites/$ACCOUNT" || true
        sed -i '' 's|ssl_certificate_key /shared.*|ssl_certificate_key '${SHARED}'/shared/web/'$ACCOUNT'/ssl/nginx.key;|' "$SHARED/server/sites/$ACCOUNT" || true

        # Change example.test to right host
        sed -i '' "s|example.test|$ACCOUNT|g" "$SHARED/server/sites/$ACCOUNT"
    fi

    # Delete SSL directory if dir exist
    if [[ -d "$SHARED/web/$ACCOUNT/ssl" ]]; then
        echo "Removing old SSL path..."
        rm -rf "$SHARED/web/$ACCOUNT/ssl"
    fi

    # Create SSL directory and certificate for securing Nginx
    if [[ ! -d "$SHARED/web/$ACCOUNT/ssl" ]]; then
        echo "Creating SSL dir..."
        mkdir -p "$SHARED/web/$ACCOUNT/ssl"

        echo "Creating $ACCOUNT certificates..."
        /usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$SHARED/web/$ACCOUNT/ssl/nginx.key" -out "$SHARED/web/$ACCOUNT/ssl/nginx.crt"
    fi

    echo ""
    echo "Please restart your nginx container..."

    echo "That's all"
fi