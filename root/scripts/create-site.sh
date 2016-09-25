#!/bin/bash

SHARED="/shared"

read -p "This removes previous certificates if exist. Do you want continue. (Y/N)? " -n 1 -r
echo    

if [[ $REPLY =~ ^[Yy]$ ]]; then

	echo "Provide an account name: "

	read ACCOUNT

	if [[ ! -d "$SHARED/$ACCOUNT" ]]; then
		echo "Creating account path and site config..."
		echo ""
		mkdir -p "$SHARED/$ACCOUNT"

		cp -r "$SHARED/templates/www" "$SHARED/$ACCOUNT/www"

		cp "$SHARED/templates/site.dev" "$SHARED/sites/$ACCOUNT"

		sed -i "s|example.dev|$ACCOUNT|g" "$SHARED/sites/$ACCOUNT"
	fi
	
    # Delete SSL directory if dir exist
	if [[ -d "$SHARED/$ACCOUNT/ssl" ]]; then
		echo "Removing old SSL path..."
		echo ""
		rm -rf "$SHARED/$ACCOUNT/ssl"
	fi

	# Create SSL directory and certificate for securing Nginx
	if [[ ! -d "$SHARED/$ACCOUNT/ssl" ]]; then
		echo "Creating SSL dir..."
		echo ""
		mkdir -p "$SHARED/$ACCOUNT/ssl"

		echo "Creating $ACCOUNT certificates..."
		echo ""
		/usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$SHARED/$ACCOUNT/ssl/nginx.key" -out "$SHARED/$ACCOUNT/ssl/nginx.crt"
	fi

	echo ""
	echo "Testing configuration, restarting nginx..."

	ps -aux | grep nginx | awk '{print $2}' | grep -E '[0-9]+' | xargs kill

	echo ""
	echo "That's all"
fi