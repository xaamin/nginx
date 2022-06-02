#!/bin/bash

SHARED="$(pwd)/shared"
DOCKER_USER=${DOCKER_USER:-'rocket'}
SERVER_PATH="$SHARED"

echo "This removes previous certificates if exists. Do you want to continue. (Y/N)? "

read ANSWER

if [[ $ANSWER =~ ^[Yy]$ ]]; then

    echo "Provide the project name: "

    read PROJECT

    if [[ -d "$SHARED/web/$PROJECT" ]]; then
        echo "Source files found. Do you want to remove them. (Y/N)? "

        read ANSWER

        if [[ $ANSWER =~ ^[Yy]$ ]]; then
            echo "Removing source files..."

            rm -rf "$SHARED/web/$PROJECT"
        fi
    fi

    echo "Provide a domain name: "

    read DOMAIN_NAME

    if [[ ! -d "$SHARED/web/$PROJECT" ]]; then
        echo "Creating conf path..."
        mkdir -p "$SHARED/server/conf/$PROJECT"

        echo "Creating log path..."
        mkdir -p "$SHARED/server/log/$PROJECT"

        echo "Creating PROJECT path and site config..."
        mkdir -p "$SHARED/web/$PROJECT"

        cp -rf "$SHARED/server/templates/site/conf/" "$SHARED/server/conf/$PROJECT/"

        cp -f "$SHARED/server/templates/site.conf" "$SHARED/server/sites/$DOMAIN_NAME"

        sed -i '' 's|root .*|root '${SERVER_PATH}'/web/'$PROJECT';|' "$SHARED/server/sites/$DOMAIN_NAME" || true
        sed -i '' 's|ssl_certificate .*|ssl_certificate '${SERVER_PATH}'/server/ssl/'$PROJECT'/nginx.crt;|' "$SHARED/server/sites/$DOMAIN_NAME" || true
        sed -i '' 's|ssl_certificate_key .*|ssl_certificate_key '${SERVER_PATH}'/server/ssl/'$PROJECT'/nginx.key;|' "$SHARED/server/sites/$DOMAIN_NAME" || true

        # Change example.test to right host
        sed -i '' "s|example.test|$DOMAIN_NAME|g" "$SHARED/server/sites/$DOMAIN_NAME"

        # Update upstream
        sed -i '' "s|fastcgi_pass .*|fastcgi_pass $PROJECT:9000;|g" "$SHARED/server/sites/$DOMAIN_NAME"

        echo "Do you want clone some repository into the site document root. (Y/N)? "

        read ANSWER

        if [[ $ANSWER =~ ^[Yy]$ ]]; then
            echo "Provide the git repository: "

            read REPOSITORY

            git clone $REPOSITORY "$SHARED/web/$PROJECT/"

        else
            cp -rf "$SHARED/server/templates/site/www/" "$SHARED/web/$PROJECT/"
        fi
    fi

    # Delete SSL directory if dir exist
    if [[ -d "$SHARED/server/ssl/$PROJECT" ]]; then
        echo "Removing old SSL path..."
        rm -rf "$SHARED/server/ssl/$PROJECT"
    fi

    # Create SSL directory and certificate for securing Nginx
    if [[ ! -d "$SHARED/server/ssl/$PROJECT" ]]; then
        echo "Creating SSL dir..."
        mkdir -p "$SHARED/server/ssl/$PROJECT"

        echo "Creating $PROJECT certificates..."
        /usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=MX/ST=Oaxaca/L=México/O=Global Fintech/OU=IT Department/CN=$DOMAIN_NAME" -keyout "$SHARED/server/ssl/$PROJECT/nginx.key" -out "$SHARED/server/ssl/$PROJECT/nginx.crt"
    fi

    # Create log files
    if [[ ! -d "$SHARED/server/log/$PROJECT" ]]; then
        echo "Creating log dir..."
        mkdir -p "$SHARED/server/log/$PROJECT"

    fi

    echo ""
    echo "Please restart your nginx container..."

    echo "That's all"
fi