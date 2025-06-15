#!/bin/sh

LOCALDIR=$(dirname "$0")
cd $LOCALDIR

cp ../../../_env_development ./.env

. ./.env 
if [ -n "$COMPOSE_PROJECT_NAME" ]; then
    # export COMPOSE_PROJECT_NAME=$COMPOSE_PROJECT_NAME
    if [ -L "../${COMPOSE_PROJECT_NAME}" ]; then
        rm "../${COMPOSE_PROJECT_NAME}"
    fi

    (cd .. ; ln -sf ${HOST_ENV} ${COMPOSE_PROJECT_NAME})
fi

./d_gen_override.sh

export DOCKER_SOCKET_PATH=$(echo $DOCKER_HOST | sed 's|unix://||')
export COMPOSE_BAKE=true
export DOCKER_BUILDKIT=1

docker compose -f ./docker-compose.yml build --no-cache

if [ $? -ne 0 ]; then
    echo "Build failed. Please check the logs above."
    exit 1
fi