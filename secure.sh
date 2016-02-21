#!/bin/bash

OVERRIDE="/data"

SSL="ssl"

# Create SSL directory and SSL certificate for securing Nginx
if [[ -d "$OVERRIDE/$SSL" ]]; then
	echo "Removing old SSL keys and dir..."
	echo ""
	rm -rf "$OVERRIDE/$SSL"
fi

if [[ ! -d "$OVERRIDE/$SSL" ]]; then
	echo "Creating SSL dir..."
	echo ""
	mkdir -p "$OVERRIDE/$SSL"
	
	echo "Starting create SSL keys..."
	echo ""
	/usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$OVERRIDE/$SSL/nginx.key" -out "$OVERRIDE/$SSL/nginx.crt"

	echo ""
	echo "That's all"
fi