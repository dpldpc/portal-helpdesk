#!/bin/bash
set -e

echo "Iniciando configura_tallstackui.sh..."
echo "Parâmetro: $@ ($(type $@))" 
echo "id: $(id -u)"

if [  -f "/var/www/${APP_NAME}/composer.json" ]; then
    cd /var/www/${APP_NAME}
    echo "Configurando ambiente..."

    composer require tallstackui/tallstackui:^2.0.0
    echo "Gerando chave de aplicação..."
    php artisan key:generate --force --no-interaction

    echo "Executando migrações..."
    php artisan migrate:fresh --seed 
    php artisan migrate --force

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

    # npm install -D tailwindcss@3 postcss autoprefixer
    # npx tailwindcss init -p

    # npm install tailwindcss @tailwindcss/vite

    cp /var/www/${APP_NAME}/vite.config.js /var/www/${APP_NAME}/vite.config.js.ori
    awk '/^import /{print} !/^import / && !done{print "import tailwindcss from '\''@tailwindcss/vite'\'';"; done=1} !/^import /{print}' vite.config.js.ori > vite.config.js
    sed -i "s|plugins:.*\[|&\ntailwindcss(),\n|" /var/www/${APP_NAME}/vite.config.js

    # cp /var/www/${APP_NAME}/vite.config.js /var/www/${APP_NAME}/vite.config.js.ori
    # head -1 /var/www/${APP_NAME}/vite.config.js.ori > /var/www/${APP_NAME}/vite.config.js
    # echo "import tailwindcss from '@tailwindcss/vite';" >> /var/www/${APP_NAME}/vite.config.js
    # tail -n +2 /var/www/${APP_NAME}/vite.config.js.ori >> /var/www/${APP_NAME}/vite.config.js

    # sed -i "s|plugins:.*\[|&\ntailwindcss(),\n|" /var/www/${APP_NAME}/vite.config.js.ori2

    # if [ -f "/var/www/${APP_NAME}/resources/css/app.css" ]; then
    #     mv /var/www/${APP_NAME}/resources/css/app.css /var/www/${APP_NAME}/resources/css/app.css.ori
    #     echo "@import \"tailwindcss\";" > /var/www/${APP_NAME}/resources/css/app.css
    #     echo "@source \"../views\";" >> /var/www/${APP_NAME}/resources/css/app.css
    #     cat /var/www/${APP_NAME}/resources/css/app.css.ori >> /var/www/${APP_NAME}/resources/css/app.css
    #     rm /var/www/${APP_NAME}/resources/css/app.css.ori
    # else
    #     echo "@import \"tailwindcss\";" > /var/www/${APP_NAME}/resources/css/app.css
    #     echo "@source \"../views\";" >> /var/www/${APP_NAME}/resources/css/app.css
    # fi

    echo "Últimos ajustes: permitindo conexões do proxy"

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

TALLSTACKJS=$(basename $(find /var/www/${APP_NAME}/vendor/tallstackui/tallstackui/dist/ -type f -name "tallstackui-*.js"))
TIPPYCSS=$(basename $(find /var/www/${APP_NAME}/vendor/tallstackui/tallstackui/dist/ -type f -name "tippy-*.css"))

    # <script src="/${APP_NAME}/tallstackui/script/tallstackui-BA56JFsq.js" defer></script>
    # <link href="/${APP_NAME}/tallstackui/style/tippy-BHH8rdGj.css" rel="stylesheet" type="text/css">

mkdir -p /var/www/${APP_NAME}/resources/views/layouts
cat > /var/www/${APP_NAME}/resources/views/layouts/app.blade.php <<EOF
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- TallStackUI e Livewire Styles -->
    <!-- <tallstackui:script />  -->
    <script src="/${APP_NAME}/tallstackui/script/${TALLSTACKJS}" defer></script>
    <link href="/${APP_NAME}/tallstackui/style/${TIPPYCSS}" rel="stylesheet" type="text/css">
    @livewireStyles

    <!-- Vite -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <script src="https://kit.fontawesome.com/a9d0042508.js" crossorigin="anonymous"></script>
    <!-- Favicon Animado -->
    <x-favicon-animado :total-frames="40" :frame-rate="10"  path="favicons" />
</head>
<body>
    <x-barra-ouvidoria />
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

    php artisan migrate

    php artisan config:clear
    php artisan config:cache
    npm run build && php artisan optimize:clear

    npm install && npm run build

    echo "Finalizando instalação..."
fi
echo "Terminando configura_tallstackui.sh..."
