#!/bin/bash
set -e

echo "Iniciando configura_env.sh..."
echo "Parâmetro: $@ ($(type $@))" 
echo "id: $(id -u)"

if [  -f "/var/www/${APP_NAME}/composer.json" ]; then
    if [  ! -f "/var/www/${APP_NAME}/CONFIGURA_ENV" ]; then
        cd /var/www/${APP_NAME}
        echo "Configurando ambiente..."
        sed -i "s/^[[:space:]]*#*[[:space:]]*DB_CONNECTION=.*/DB_CONNECTION=${DB_CONNECTION}/" /var/www/${APP_NAME}/.env 
        sed -i "s/^[[:space:]]*#*[[:space:]]*DB_HOST=.*/DB_HOST=${DB_HOST}/" /var/www/${APP_NAME}/.env 
        sed -i "s/^[[:space:]]*#*[[:space:]]*DB_PORT=.*/DB_PORT=${DB_PORT}/" /var/www/${APP_NAME}/.env
        sed -i "s/^[[:space:]]*#*[[:space:]]*DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE}/" /var/www/${APP_NAME}/.env
        sed -i "s/^[[:space:]]*#*[[:space:]]*DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME}/" /var/www/${APP_NAME}/.env
        sed -i "s/^[[:space:]]*#*[[:space:]]*DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/" /var/www/${APP_NAME}/.env 
        sed -i "s/^[[:space:]]*#*[[:space:]]*APP_ENV=.*/APP_ENV=${APP_ENV}/" /var/www/${APP_NAME}/.env      
        sed -i "s|^APP_DEBUG=.*|APP_DEBUG=${APP_DEBUG}|" /var/www/${APP_NAME}/.env      
        sed -i "s|^APP_NAME=.*|APP_NAME=${APP_NAME}|" /var/www/${APP_NAME}/.env      
        sed -i "s|^APP_URL=.*|APP_URL=${APP_URL_BASE}/${APP_NAME}|" /var/www/${APP_NAME}/.env    
        sed -i "s/REDIS_HOST=.*/REDIS_HOST=${REDIS_HOST}/" /var/www/${APP_NAME}/.env 
        sed -i "s/REDIS_PASSWORD=.*/REDIS_PASSWORD=${REDIS_PASSWORD}/" /var/www/${APP_NAME}/.env 
        sed -i "s/REDIS_PORT=.*/REDIS_PORT=${REDIS_PORT}/" /var/www/${APP_NAME}/.env

        sed -i "s|VITE_APP_NAME=.*|VITE_APP_NAME=${APP_NAME}|" /var/www/${APP_NAME}/.env      

        sed -i "s|MAIL_MAILER=.*|MAIL_MAILER=smtp|" /var/www/${APP_NAME}/.env      
        sed -i "s|MAIL_SCHEME=.*|MAIL_SCHEME=http|" /var/www/${APP_NAME}/.env      
        sed -i "s|MAIL_HOST=.*|MAIL_HOST=mailpit|" /var/www/${APP_NAME}/.env      
        sed -i "s|MAIL_PORT=.*|MAIL_PORT=1025|" /var/www/${APP_NAME}/.env      

        sed -i "s|MAIL_FROM_NAME=.*|MAIL_FROM_NAME=${APP_NAME}|" /var/www/${APP_NAME}/.env      
        sed -i "s|MAIL_FROM_ADDRESS=.*|MAIL_FROM_ADDRESS=${APP_NAME}@${APP_HOST}|" /var/www/${APP_NAME}/.env      

        grep ASSET_URL /var/www/${APP_NAME}/.env && sed -i "s|ASSET_URL=.*|ASSET_URL=${APP_URL_BASE}|" /var/www/${APP_NAME}/.env || echo "ASSET_URL=${APP_URL_BASE}/${APP_NAME}" >> /var/www/${APP_NAME}/.env

        echo "==== Conteúdo do arquivo .env: ===="
        cat /var/www/${APP_NAME}/.env
        echo "==== Fim do arquivo .env       ===="
        php artisan migrate 

        touch /var/www/${APP_NAME}/CONFIGURA_ENV
    else 
        echo "Sem ação. Saindo..."
    fi

fi
echo "Terminando configura_env.sh..."
