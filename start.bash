#!/bin/bash

#
# start.bash
#

NGINX="/etc/nginx"
OVERRIDE="/data"

CONFIG="nginx.conf"
SITES="sites"
LOGS="logs"
WWW="www"
AVAILABLE="sites-available"
ENABLED="sites-enabled"

# Symlink sites directory
if [[ -d "$OVERRIDE/$SITES" ]]; then  
  rm -fr "$AVAILABLE"
  ln -s "$OVERRIDE/$SITES" "$AVAILABLE"

  rm -fr "$ENABLED"
  ln -s "$OVERRIDE/$SITES" "$ENABLED"
fi

# Create logs directory
if [[ ! -d "$OVERRIDE/$LOGS" ]]; then
	mkdir -p "$OVERRIDE/$LOGS"
fi

# Create www directory
if [[ ! -d "$OVERRIDE/$WWW" ]]; then
	mkdir -p "$OVERRIDE/$WWW"
fi

# Symlink config file.
if [[ -f "$OVERRIDE/$CONFIG" ]]; then
  rm -f "$CONFIG"
  ln -s "$OVERRIDE/$CONFIG" "$CONFIG"
fi

/usr/bin/supervisord -n