#!/bin/bash
export SHARED_VOLUME="$(pwd)/shared"

export HOST_USER_ID=$(id -u $(whoami))
export HOST_GROUP_ID=$(id -g $(whoami))

docker-compose $@