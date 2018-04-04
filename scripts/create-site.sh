#!/bin/bash

SHARED="shared/server"

echo "This removes previous certificates if exist. Do you want continue. (Y/N)? "

read ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then

    echo "Provide an account name: "

    read ACCOUNT

    if [[ ! -d "$SHARED/web/$ACCOUNT" ]]; then
        echo "Creating account path and site config..."
        echo ""
        mkdir -p "$SHARED/web/$ACCOUNT"

        cp -rf "$SHARED/templates/site/." "$SHARED/web/$ACCOUNT/"

        cp -f "$SHARED/templates/site.conf" "$SHARED/sites/$ACCOUNT"

        sed -i "s|example.dev|$ACCOUNT|g" "$SHARED/sites/$ACCOUNT"
    fi

    # Delete SSL directory if dir exist
    if [[ -d "$SHARED/web/$ACCOUNT/ssl" ]]; then
        echo "Removing old SSL path..."
        echo ""
        rm -rf "$SHARED/web/$ACCOUNT/ssl"
    fi

    # Create SSL directory and certificate for securing Nginx
    if [[ ! -d "$SHARED/web/$ACCOUNT/ssl" ]]; then
        echo "Creating SSL dir..."
        echo ""
        mkdir -p "$SHARED/web/$ACCOUNT/ssl"

        echo "Creating $ACCOUNT certificates..."
        echo ""
        /usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$SHARED/web/$ACCOUNT/ssl/nginx.key" -out "$SHARED/web/$ACCOUNT/ssl/nginx.crt"
    fi

    echo ""
    echo "Please restart your nginx container..."

    echo ""
    echo "That's all"
fi