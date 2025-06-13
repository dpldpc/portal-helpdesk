#!/bin/sh

LOCALDIR=$(dirname "$0")
cd $LOCALDIR

cp ../../../_env_development ./.env
. ./.env 

echo "volumes:" > docker-compose.override.yml
echo "  ${COMPOSE_PROJECT_NAME}-mysql-data:" >> docker-compose.override.yml
echo "  # ${COMPOSE_PROJECT_NAME}-mailpit-data:" >> docker-compose.override.yml
echo "  ${COMPOSE_PROJECT_NAME}-composer-cache:" >> docker-compose.override.yml
echo "  ${COMPOSE_PROJECT_NAME}-npm-cache:" >> docker-compose.override.yml
echo "  ${COMPOSE_PROJECT_NAME}-yarn-cache:" >> docker-compose.override.yml

