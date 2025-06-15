#!/bin/bash
set -e

echo "Iniciando o container..."
echo "Parâmetro: $@ ($(type $@))" 
echo "id: $(id -u)"
# echo "mysql: $(type mysql)"

mkdir -p  /var/www/${APP_NAME}

# Etapa 1: Instalar Laravel se necessário
if [ ! -f "/var/www/${APP_NAME}/composer.json" ]; then
    echo "Instalando Laravel..."

    
    echo "Rodando create-project do Laravel em /var/www/${APP_NAME}..."
    cd /var/www
    # composer create-project laravel/laravel ${APP_NAME} --prefer-dist --no-interaction --remove-vcs
    composer create-project laravel/laravel ${APP_NAME} --prefer-dist --no-interaction --remove-vcs

    
    cp /tmp/.env.example /var/www/${APP_NAME}/.env.example
    cp /var/www/${APP_NAME}/.env.example /var/www/${APP_NAME}/.env 

    # Etapa 2: Configurar ambiente
    echo "Configurando ambiente..."
    sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=${DB_CONNECTION}/" /var/www/${APP_NAME}/.env 
    sed -i "s/DB_HOST=.*/DB_HOST=${DB_HOST}/" /var/www/${APP_NAME}/.env 
    sed -i "s/DB_PORT=.*/DB_PORT=${DB_PORT}/" /var/www/${APP_NAME}/.env
    sed -i "s/DB_DATABASE=.*/DB_DATABASE=${MYSQL_DATABASE}/" /var/www/${APP_NAME}/.env
    sed -i "s/DB_USERNAME=.*/DB_USERNAME=${MYSQL_USER}/" /var/www/${APP_NAME}/.env
    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${MYSQL_PASSWORD}/" /var/www/${APP_NAME}/.env 
    sed -i "s|^APP_ENV=.*|APP_ENV=${APP_ENV}|" /var/www/${APP_NAME}/.env      
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

    echo "ASSET_URL=${APP_URL_BASE}/${APP_NAME}" >> /var/www/${APP_NAME}/.env

    # Etapa 3: Instalar dependências
    echo "Instalando/atualizando dependências..."
    cd /var/www/${APP_NAME}   
    echo "Instalando dependências (1/2) composer install..."
    composer require livewire/livewire
    composer install --optimize-autoloader --no-interaction  
    echo "Instalando dependências (2/2) npm install ..."
    npm install -D tailwindcss @tailwindcss/vite @tailwindcss/forms postcss autoprefixer --cache /tmp/npm-cache --no-audit
    npm install --cache /tmp/npm-cache --no-audit

    sed -i "s|@import 'tailwindcss';|&\n@import '../../vendor/tallstackui/tallstackui/css/v4.css';\n@plugin '@tailwindcss/forms';\n@source '../../vendor/tallstackui/tallstackui/**/*.php';\n|g" /var/www/${APP_NAME}/resources/css/app.css

    mkdir -p /var/www/${APP_NAME}/resources/views/layouts

    composer require tallstackui/tallstackui:^2.0.0
    # npm run build && php artisan optimize:clear
    
    # Etapa 5: Garantir chave de aplicação
    echo "Gerando chave de aplicação..."
    php artisan key:generate --force --no-interaction

    # Etapa 6: Executar migrações
    echo "Executando migrações..."
    php artisan migrate:fresh --seed 
    php artisan migrate --force

    # Etapa 7: Publicar ativos do Livewire
    echo "Publicando ativos do Livewire..."
    php artisan vendor:publish --force --tag=livewire:assets
    php artisan vendor:publish --force --tag=livewire:config

    echo "Reconfigurando o Livewire..."
    sed -i "s|<\?php|&\n\nuse Livewire\\\\Livewire;|" /var/www/${APP_NAME}/routes/web.php

    echo "" >> /var/www/${APP_NAME}/routes/web.php
    echo "" >> /var/www/${APP_NAME}/routes/web.php
    echo 'Livewire::setUpdateRoute(function ($handle) {' >> /var/www/${APP_NAME}/routes/web.php
    echo "return Route::post('/${APP_NAME}/livewire/update', \$handle);" >> /var/www/${APP_NAME}/routes/web.php
    echo '});' >> /var/www/${APP_NAME}/routes/web.php
    sed -i "s|return Route::post('/${APP_NAME}/livewire/update', \$handle);|return Route::post('/${APP_NAME}/livewire/update', \$handle)->name('livewire.update');|" /var/www/${APP_NAME}/routes/web.php

    echo "Configurando o Tailwind..."
    # cp /var/www/${APP_NAME}/vite.config.js /tmp/${APP_NAME}_vite.config.js
    # echo  "import tailwindcss from '@tailwindcss/vite'" > /var/www/${APP_NAME}/vite.config.js
    # cat /tmp/${APP_NAME}_vite.config.js >> /var/www/${APP_NAME}/vite.config.js
   

    sed -i "s|plugins:.*\[|&\ntailwindcss(),\n|" /var/www/${APP_NAME}/vite.config.js
    echo "@import \"tailwindcss\";" >> /var/www/${APP_NAME}/resources/css/app.css

    echo "Últimos ajustes: permitindo conexões do proxy"
    #sed -i "s|protected \$proxies;|protected \$proxies = '*';  // Confiar em todos os proxies|" /var/www/${APP_NAME}/app/Http/Middleware/TrustProxies.php
    #/var/www/${APP_NAME}/app/Http/Middleware/TrustProxies.php

    echo "" >> /var/www/${APP_NAME}/bootstrap/app.php
    echo "\$app->withMiddleware(function (Middleware \$middleware) {" >> /var/www/${APP_NAME}/bootstrap/app.php
    echo "    \$middleware->trustProxies(" >> /var/www/${APP_NAME}/bootstrap/app.php
    echo "        at: '*'," >> /var/www/${APP_NAME}/bootstrap/app.php
    echo "        headers: Request::HEADER_X_FORWARDED_ALL" >> /var/www/${APP_NAME}/bootstrap/app.php
    echo "    );" >> /var/www/${APP_NAME}/bootstrap/app.php
    echo "});" >> /var/www/${APP_NAME}/bootstrap/app.php
    echo "" >> /var/www/${APP_NAME}/bootstrap/app.php


    APP_PROVIDER="/var/www/${APP_NAME}/app/Providers/AppServiceProvider.php"
    SCHEME_CODE="        URL::forceRootUrl(Config::get('app.url'));\n        URL::forceScheme('https');"
    TMP_FILE="${APP_PROVIDER}.tmp"
    USE_IMPORT="use Illuminate\Support\Facades\URL;\nuse Illuminate\Support\Facades\Config;"
    BACKUP_FILE="${APP_PROVIDER}.bak"

    # Se já existe a chamada, não faz nada
    if grep -Fq "URL::forceScheme('https');" "$APP_PROVIDER"; then
        echo "✅ Já existe URL::forceScheme('https'); Nenhuma alteração necessária."
        exit 0
    fi

    awk -v insert="$SCHEME_CODE" -v use_line="$USE_IMPORT" '
    BEGIN {
        in_boot = 0
        url_use_already_present = 0
        last_use_line_index = -1
    }

    {
        lines[NR] = $0
        if ($0 == use_line) {
            url_use_already_present = 1
        }

        if ($0 ~ /^use /) {
            last_use_line_index = NR
        }

        if ($0 ~ /public function boot\(\)/) {
            boot_found = 1
            boot_line = NR
        }
    }

    END {
        # Inserir o use URL se ainda não estiver presente
        if (!url_use_already_present && last_use_line_index != -1) {
            for (i = NR + 1; i > last_use_line_index + 1; i--) {
                lines[i] = lines[i - 1]
            }
            lines[last_use_line_index + 1] = use_line
            NR++
        }

        in_boot = 0
        for (i = 1; i <= NR; i++) {
            print lines[i]

            if (lines[i] ~ /public function boot\(\)/) {
                in_boot = 1
                continue
            }

            if (in_boot && lines[i] ~ /{/) {
                split(insert, code_lines, "\n")
                for (j = 1; j <= length(code_lines); j++) {
                    print code_lines[j]
                }
                in_boot = 0
            }
        }
    }
    ' "$APP_PROVIDER" > "$TMP_FILE"

    # Substitui o arquivo original
    if [ -s "$TMP_FILE" ]; then
        cp "$APP_PROVIDER" "$BACKUP_FILE"
        mv "$TMP_FILE" "$APP_PROVIDER"
        echo "✅ Inserções concluídas com sucesso. Backup salvo como $(basename "$BACKUP_FILE")"
    else
        echo "❌ Erro: arquivo temporário não gerado. Abortando."
    fi

    composer require laravel/breeze --dev
    php artisan breeze:install livewire
    npm install && npm run build
    php artisan migrate

cat > /var/www/${APP_NAME}/resources/views/layouts/app.blade.php <<EOF
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- TallStackUI e Livewire Styles -->
    <!-- <tallstackui:script />  -->
    <script src="/${APP_NAME}/tallstackui/script/tallstackui-BA56JFsq.js" defer></script>
    <link href="/${APP_NAME}/tallstackui/style/tippy-BHH8rdGj.css" rel="stylesheet" type="text/css">
    @livewireStyles

    <!-- Vite -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body>
    @yield('content')
    @livewireScripts
</body>
</html>
EOF

cat > /var/www/${APP_NAME}/resources/views/welcome.blade.php <<'EOF'
@extends('layouts.app')

@section('content')
    <div style="text-align:center; margin-top:50px;">
        <h1>Bem-vindo ao Laravel 12!</h1>
        <p>Seu ambiente está pronto 🚀</p>
    </div>
@endsection
EOF

    php artisan config:clear
    php artisan config:cache
    npm run build && php artisan optimize:clear

    echo "Finalizando instalação..."
else
    echo "Laravel já está instalado. Pulando instalação..."

    echo "Instalando/atualizando dependências..."
    cd /var/www/${APP_NAME}   
    echo "Instalando dependências (1/2) composer install..."
    composer install --optimize-autoloader --no-interaction  
    echo "Instalando dependências (2/2) npm install ..."
    npm install --cache /tmp/npm-cache --no-audit

    echo "Executando migrações (se necessário)..."
    php artisan migrate 

    echo "Limpando cache de rotas..."
    php artisan route:clear
    # php artisan route:cache
    php artisan config:clear
    php artisan optimize:clear

fi

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
