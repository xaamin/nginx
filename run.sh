#!/bin/bash
export DOCKER_USER=${DOCKER_USER:-'xaamin'}

export USER=$DOCKER_USER

if [ -f '.mysql.env' ]; then
    export MYSQL_ROOT_PASSWORD=$(cat .mysql.env)
else
    export MYSQL_ROOT_PASSWORD=$(openssl rand -base64 32)

    echo $MYSQL_ROOT_PASSWORD > .mysql.env
fi

if [ -f '.ssh.env' ]; then
    export SSH_PASSWORD=$(cat .ssh.env)
else
    export SSH_PASSWORD=$(openssl rand -base64 32)

    echo $SSH_PASSWORD > .ssh.env
fi

export SHARED_VOLUME="/home/$DOCKER_USER"

export USER_ID=$(id -u $(whoami))

export USER_GID=$(id -g $(whoami))

export TZ=America/Mexico_City

SSH_KEY_FILE=$(pwd)/ssh/id_rsa

if [ ! -f $SSH_KEY_FILE ]; then
    ssh-keygen -t rsa -b 4096 -C "$USER" -f $SSH_KEY_FILE
fi

echo ""
echo "========================================="
echo "Using shared volume: '$SHARED_VOLUME'"
echo "Using timezone: '$TZ'"
echo "MySQL password: '$MYSQL_ROOT_PASSWORD'"
echo "SSH password: '$SSH_PASSWORD'"
echo "Creating as user $USER with UID $USER_ID and GUID $USER_GID"
echo "========================================="
echo ""

 docker-compose up -d