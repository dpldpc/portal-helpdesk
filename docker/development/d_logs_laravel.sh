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

export APP_NAME

export DOCKER_SOCKET_PATH=$(echo $DOCKER_HOST | sed 's|unix://||')

docker compose exec php find /var/www/${APP_NAME}/storage/logs/ -ls 
docker compose exec php ls -l /var/www/${APP_NAME}/storage/
docker compose exec php ls -l /var/www/${APP_NAME}/storage/logs/
docker compose exec php tail -f /var/www/${APP_NAME}/storage/logs/laravel.log
