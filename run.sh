#!/bin/bash
export SHARED_VOLUME=$(pwd)

echo "Using path '$SHARED_VOLUME' for shared volume"

export HOST_USER_ID=$(id -u $(whoami)) && export HOST_GROUP_ID=$(id -g $(whoami)) && docker-compose up -d