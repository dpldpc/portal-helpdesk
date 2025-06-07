#!/bin/sh

LOCALDIR=$(dirname "$0")
cd $LOCALDIR

export DOCKER_SOCKET_PATH=$(echo $DOCKER_HOST | sed 's|unix://||')

docker compose down
