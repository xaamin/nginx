#!/usr/bin/env bash
set -e

# Apply permissions.
echo "Setting permissions for all the www directories..."

find /shared/web/ -maxdepth 3 -type d | grep www | grep -v .git | xargs chown -R $DOCKER_USER:$DOCKER_GROUP || true

echo "Applied permissions to all the www directories."