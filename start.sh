#!/bin/bash

NGINX="/etc/nginx"
OVERRIDE="/shared"

CONFIG="nginx.conf"
SITES="sites"
SSL="ssl"
LOGS="logs"
WWW="www"
AVAILABLE="sites-available"
ENABLED="sites-enabled"

# Symlink sites directory
if [[ -d "$OVERRIDE/$SITES" ]]; then  
	echo "Creating symlinks to available sites..."
	echo ""
  	rm -fr "$AVAILABLE"
  	ln -s "$OVERRIDE/$SITES" "$AVAILABLE"

  	rm -fr "$ENABLED"
  	ln -s "$OVERRIDE/$SITES" "$ENABLED"
  	echo "Symlinks created"
	echo ""
fi

# Create logs directory
if [[ ! -d "$OVERRIDE/$LOGS" ]]; then
	echo "Creating log dir..."
	echo ""
	mkdir -p "$OVERRIDE/$LOGS"
	echo "Log dir created"
	echo ""
fi

# Symlink config file.
if [[ -f "$OVERRIDE/$CONFIG" ]]; then
	echo "Creating symlinks to custom nginx config file.."
	echo ""
  	rm -f "$CONFIG"
  	ln -s "$OVERRIDE/$CONFIG" "$CONFIG"
  	echo "Symlink created"
	echo ""
fi

/usr/bin/supervisord -n