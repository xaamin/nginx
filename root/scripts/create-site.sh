#!/bin/bash

OVERRIDE="/shared"

read -p "This removes previous certificates if exist. Do you want continue. (Y/N)? " -n 1 -r
echo    

if [[ $REPLY =~ ^[Yy]$ ]]; then

	echo "Provide an account name: "

	read ACCOUNT

	if [[ ! -d "$OVERRIDE/$ACCOUNT/www" ]]; then
		echo "Creating www dir..."
		echo ""
		mkdir -p "$OVERRIDE/$ACCOUNT/www"
	fi
	
    # Delete SSL directory if dir exist
	if [[ -d "$OVERRIDE/$ACCOUNT/ssl" ]]; then
		echo "Removing old SSL keys and dir..."
		echo ""
		rm -rf "$OVERRIDE/$ACCOUNT/ssl"
	fi

	# Create SSL directory and certificate for securing Nginx
	if [[ ! -d "$OVERRIDE/$ACCOUNT" ]]; then
		echo "Creating SSL dir..."
		echo ""
		mkdir -p "$OVERRIDE/$ACCOUNT/ssl"

		echo "Creating $ACCOUNT certificates..."
		echo ""
		/usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$OVERRIDE/$ACCOUNT/ssl/nginx.key" -out "$OVERRIDE/$ACCOUNT/ssl/nginx.crt"

		echo ""
		echo "That's all"
	fi
fi