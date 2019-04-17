#!/bin/bash
export DOCKER_USER=${DOCKER_USER:-'xaamin'}

export SHARED_VOLUME="/home/$DOCKER_USER"

echo "Using path '$SHARED_VOLUME' for shared volume"

export USER_ID=$(id -u $(whoami)) && export GROUP_ID=$(id -g $(whoami)) && docker-compose up -d