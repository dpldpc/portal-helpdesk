#!/bin/bash
set -e

echo "Iniciando set_env.sh..."
echo "Parâmetro: $@ ($(type $@))" 
echo "id: $(id -u)"
# echo "mysql: $(type mysql)"

if [ ! -f "/var/www/${APP_NAME}/SET_ENV" ]; then

    echo 'export PATH="$PATH:$HOME/.composer/vendor/bin/"' >> /root/.bashrc

    echo 'export SHELL' >> /root/.bashrc 

    echo 'export LS_OPTIONS="--color=auto"' >> /root/.bashrc 
    echo 'eval "$(dircolors)"' >> /root/.bashrc
    echo 'alias ls="ls $LS_OPTIONS"' >> /root/.bashrc 
    echo 'alias ll="ls $LS_OPTIONS -l"' >> /root/.bashrc
    echo 'alias l="ls $LS_OPTIONS -lA"' >> /root/.bashrc


    export PATH="$PATH:$HOME/.composer/vendor/bin/"

    if [ ! -f "/var/www/${APP_NAME}/composer.json" ]; then
        cd /var/www
        composer global require laravel/installer
        pwd 

        cd /var/www

        pwd
        echo "Instalando Laravel..."
        # script -q -c "laravel new ${APP_NAME} --no-interaction --livewire --pest --npm " /dev/null
        # laravel new ${APP_NAME} --no-interaction --livewire --pest --npm 
        laravel new ${APP_NAME} --no-interaction --pest --npm
        echo "laravel Retornou ${?}"  

        cd ${APP_NAME}

        composer require laravel/jetstream
        php artisan jetstream:install livewire
        npm install
        npm run build
        php artisan migrate
    fi

    mkdir -p /var/www/${APP_NAME}/public 
    mkdir -p /var/www/${APP_NAME}/storage/
    mkdir -p /var/www/${APP_NAME}/bootstrap/cache/

    echo "Vai mudar permissões de /var/www/${APP_NAME}/storage..."
    find /var/www/${APP_NAME}/storage -type d -exec chmod 777 {} \;
    find /var/www/${APP_NAME}/storage -type f -exec chmod 666 {} \;

    echo "Vai mudar permissões de /var/www/${APP_NAME}/bootstrap/cache..." 
    find /var/www/${APP_NAME}/bootstrap/cache -type d -exec chmod 777 {} \;
    find /var/www/${APP_NAME}/bootstrap/cache -type f -exec chmod 666 {} \;

    echo "Fim de set_env.sh..."
    # chown -R www:www /var/www
    # chown -R www:www /var/www/${PROJECT_NAME}
    # chown -R www:www /var/www/${PROJECT_NAME}/*

    # exec  su - www -c "/usr/local/sbin/php-fpm"

    touch /var/www/${APP_NAME}/SET_ENV
else 
    echo "Sem ação. Saindo..."
fi
echo "Terminando set_env.sh..."
