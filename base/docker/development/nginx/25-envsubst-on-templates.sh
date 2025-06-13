#!/bin/sh
set -e

# Extrair o hostname da URL (remove http:// ou https://)
# export APP_HOST=$(echo ${APP_URL_BASE} | sed -e 's|^[^/]*//||' -e 's|:.*||' -e 's|/.*||')
# export APP_PORT=$(echo ${APP_URL_BASE} | sed -e 's|^[^/]*//||' -e 's|.*:||' -e 's|/.*||') 

# # Extrair o hostname da URL (remove http:// ou https://)
# APP_HOST=$(echo ${APP_URL_BASE} | sed -e 's|^[^/]*//||' -e 's|:.*||' -e 's|/.*||')
# export APP_HOST

# # Detectar o protocolo da URL
# PROTOCOL=$(echo ${APP_URL_BASE} | sed -e 's|://.*||')

# # Extrair a porta da URL
# PORT=$(echo ${APP_URL_BASE} | sed -e 's|^[^/]*//||' -e 's|.*:||' -e 's|/.*||')

# export APP_HTTPS_PORT=443
# export APP_PORT=80

# # Definir as portas padrão com base no protocolo
# if [ "$PROTOCOL" = "https" ]; then
#     # Se a porta estiver vazia ou for a mesma que o host, usar 443 (padrão HTTPS)
#     if [ -z "$PORT" ] || [ "$PORT" = "$APP_HOST" ]; then
#         APP_HTTPS_PORT=443
#     else
#         APP_HTTPS_PORT=$PORT
#     fi
#     export APP_HTTPS_PORT
#     echo "Protocolo HTTPS detectado, usando porta: $APP_HTTPS_PORT"
# else
#     # Se a porta estiver vazia ou for a mesma que o host, usar 80 (padrão HTTP)
#     if [ -z "$PORT" ] || [ "$PORT" = "$APP_HOST" ]; then
#         APP_PORT=80
#     else
#         APP_PORT=$PORT
#     fi
#     export APP_PORT
#     echo "Protocolo HTTP detectado, usando porta: $APP_PORT"
# fi 


# Substituir variáveis no template

# ln -s /dev/stderr  /var/log/nginx/error_ssl.log
# ln -s /dev/stdout  /var/log/nginx/access_ssl.log

envsubst '$APP_HOST $APP_NAME $PHP_HOST' < /etc/nginx/templates/default.template.conf > /etc/nginx/conf.d/default.conf

# echo "envsubst < /etc/nginx/templates/default.template.conf > /etc/nginx/conf.d/default.conf"

date 
echo "APP_HOST: ${APP_HOST}"
echo "APP_NAME: ${APP_NAME}"
echo "APP_URL_BASE: ${APP_URL_BASE}"
echo "APP_URL: ${APP_URL}"
# ls -l /etc/nginx/ssl/ 


echo "Nginx configurado para servir ${APP_NAME} em ${APP_HOST}"
echo "Conteúdo de /var/www/${APP_NAME}:"
ls -l /var/www/${APP_NAME} 
echo ""
echo "Conteúdo de /var/www/${APP_NAME}/public:"
ls -l /var/www/${APP_NAME}/public 

# echo "==={ /etc/nginx/conf.d/default.conf}=== begin"
# cat /etc/nginx/conf.d/default.conf
# echo "==={ /etc/nginx/conf.d/default.conf}=== end"

# Executar nginx
# exec nginx -g 'daemon off;'