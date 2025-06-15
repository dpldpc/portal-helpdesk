#!/bin/sh

LOCALDIR=$(dirname "$0")
cd $LOCALDIR

cp ../../../_env_development ./.env

. ./.env 
if [ -n "$COMPOSE_PROJECT_NAME" ]; then
    export COMPOSE_PROJECT_NAME=$COMPOSE_PROJECT_NAME

    (cd .. ; ln -sf ${HOST_ENV} ${COMPOSE_PROJECT_NAME})
fi

./d_gen_override.sh

export DOCKER_SOCKET_PATH=$(echo $DOCKER_HOST | sed 's|unix://||')

docker compose restart
