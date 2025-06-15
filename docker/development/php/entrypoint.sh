#!/bin/bash
set -e

echo "Iniciando o container..."
echo "Parâmetro: $@ ($(type $@))" 
echo "id: $(id -u)"
# echo "mysql: $(type mysql)"


echo "chamando set_env.sh..." 
/usr/local/bin/set_env.sh
echo "voltou de set_env.sh..." 

echo "chamando configura_env.sh..." 
/usr/local/bin/configura_env.sh
echo "voltou de configura_env.sh..." 

echo "chamando configura_tallstackui.sh..." 
/usr/local/bin/configura_tallstackui.sh
echo "voltou de configura_tallstackui.sh..." 

cd /var/www/${APP_NAME}
mkdir -p /var/www/${APP_NAME}/packages/Dgti
cp /var/stuff/laravel-favicon-animado.tar.gz /var/www/${APP_NAME}/packages/Dgti
/usr/local/bin/installpackage.sh 

# if [ ! -f "/var/www/${APP_NAME}/composer.json" ]; then
#     cd /var/www
#     composer global require laravel/installer
#     echo 'export PATH="$PATH:$HOME/.composer/vendor/bin/"' >> /root/.bashrc

#     echo 'export SHELL' >> /root/.bashrc 

#     echo 'export LS_OPTIONS="--color=auto"' >> /root/.bashrc 
#     echo 'eval "$(dircolors)"' >> /root/.bashrc
#     echo 'alias ls="ls $LS_OPTIONS"' >> /root/.bashrc 
#     echo 'alias ll="ls $LS_OPTIONS -l"' >> /root/.bashrc
#     echo 'alias l="ls $LS_OPTIONS -lA"' >> /root/.bashrc
# fi


# mkdir -p /var/www/${APP_NAME}/public 
# mkdir -p /var/www/${APP_NAME}/storage/
# mkdir -p /var/www/${APP_NAME}/bootstrap/cache/

echo "Vai mudar permissões de /var/www/${APP_NAME}/storage..."
find /var/www/${APP_NAME}/storage -type d -exec chmod 777 {} \;
find /var/www/${APP_NAME}/storage -type f -exec chmod 666 {} \;

echo "Vai mudar permissões de /var/www/${APP_NAME}/bootstrap/cache..." 
find /var/www/${APP_NAME}/bootstrap/cache -type d -exec chmod 777 {} \;
find /var/www/${APP_NAME}/bootstrap/cache -type f -exec chmod 666 {} \;


# chown -R www:www /var/www
# chown -R www:www /var/www/${PROJECT_NAME}
# chown -R www:www /var/www/${PROJECT_NAME}/*

# exec  su - www -c "/usr/local/sbin/php-fpm"
exec   "/usr/local/sbin/php-fpm"  
