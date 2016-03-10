#!/bin/bash

OVERRIDE="/shared/ssl"

read -p "This removes previous certificates. Do you want continue. (Y/N)? " -n 1 -r
echo    

if [[ $REPLY =~ ^[Yy]$ ]]; then

	echo "Provide account name for generated certificates: "

	read ACCOUNT
	
    # Create SSL directory and certificate for securing Nginx
	if [[ -d "$OVERRIDE/$ACCOUNT" ]]; then
		echo "Removing old SSL keys and dir..."
		echo ""
		rm -rf "$OVERRIDE/$ACCOUNT"
	fi

	if [[ ! -d "$OVERRIDE/$ACCOUNT" ]]; then
		echo "Creating SSL dir..."
		echo ""
		mkdir -p "$OVERRIDE/$ACCOUNT"
		
		echo "Starting create ACCOUNT keys..."
		echo ""
		/usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$OVERRIDE/$ACCOUNT/nginx.key" -out "$OVERRIDE/$ACCOUNT/nginx.crt"

		echo ""
		echo "That's all"
	fi
fi