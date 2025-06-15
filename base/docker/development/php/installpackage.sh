#!/bin/bash

VENDOR="Dgti"
PACKAGE="laravel-favicon-animado"
PACKAGE_TAR="packages/$VENDOR/${PACKAGE}.tar.gz"
PACKAGE_DIR="packages/$VENDOR/$PACKAGE"

# 1. Verifica se o arquivo existe
if [ ! -f "$PACKAGE_TAR" ]; then
  echo "Arquivo $PACKAGE_TAR não encontrado!"
  exit 1
fi

# 2. Extrai o pacote
mkdir -p packages/$VENDOR
tar xzf $PACKAGE_TAR -C packages/$VENDOR

# 3. Adiciona o repositório local ao composer.json (se ainda não existe)
if ! grep -q "$PACKAGE_DIR" composer.json; then
  TMP=$(mktemp)
  jq --arg url "$PACKAGE_DIR" \
    '.repositories += [{"type":"path","url":$url}]' composer.json > "$TMP" && mv "$TMP" composer.json
  echo "Repositório local adicionado ao composer.json"
else
  echo "Repositório local já existe no composer.json"
fi

# 4. Instala o pacote via Composer
composer require $VENDOR/$PACKAGE

# 5. Publica os assets (favicons)
php artisan vendor:publish --tag=public

echo "Pacote $PACKAGE instalado e assets publicados!"
echo "Componentes disponíveis: <x-favicon-animado> e <x-barra-ouvidoria>"
