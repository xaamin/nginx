#!/bin/bash

OVERRIDE="/data"

SSL="ssl"

# Create SSL directory and SSL certificate for securing Nginx
if [[ ! -d "$OVERRIDE/$SSL" ]]; then
	mkdir -p "$OVERRIDE/$SSL"
	/usr/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$OVERRIDE/$SSL/nginx.key" -out "$OVERRIDE/$SSL/nginx.crt"
fi