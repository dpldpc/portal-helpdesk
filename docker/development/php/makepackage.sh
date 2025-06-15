#!/bin/bash

# Configurações
VENDOR="dgti"
PACKAGE="laravel-favicon-animado"
NAMESPACE="dgti\\FaviconAnimado"
COMPONENTS_ORIG_PATH="/var/www/portal/resources/views/components"
FAVICONS_ORIG_PATH="/var/www/portal/public/favicons"
PACKAGE_BASE="packages/$VENDOR/$PACKAGE"

# Cria estrutura de diretórios
mkdir -p $PACKAGE_BASE/src
mkdir -p $PACKAGE_BASE/resources/views/components
mkdir -p $PACKAGE_BASE/public

# Copia os componentes Blade
cp $COMPONENTS_ORIG_PATH/favicon-animado.blade.php $PACKAGE_BASE/resources/views/components/favicon-animado.blade.php
cp $COMPONENTS_ORIG_PATH/barra-ouvidoria.blade.php $PACKAGE_BASE/resources/views/components/barra-ouvidoria.blade.php

# Copia a pasta favicons e seu conteúdo
if [ -d "$FAVICONS_ORIG_PATH" ]; then
  cp -r $FAVICONS_ORIG_PATH $PACKAGE_BASE/public/
else
  echo "Atenção: Pasta $FAVICONS_ORIG_PATH não encontrada. Nenhum favicon foi copiado."
fi

# Cria o ServiceProvider
cat > $PACKAGE_BASE/src/FaviconAnimadoServiceProvider.php <<EOL
<?php

namespace dgti\\FaviconAnimado;

use Illuminate\\Support\\ServiceProvider;
use Illuminate\\Support\\Facades\\Blade;

class FaviconAnimadoServiceProvider extends ServiceProvider
{
    public function boot()
    {
        \$this->loadViewsFrom(__DIR__.'/../resources/views', 'favicon-animado');
        \$this->publishes([
            __DIR__.'/../public/favicons' => public_path('favicons'),
        ], 'public');
        Blade::component('favicon-animado::components.favicon-animado', 'favicon-animado');
        Blade::component('favicon-animado::components.barra-ouvidoria', 'barra-ouvidoria');
    }

    public function register()
    {
        //
    }
}
EOL

# Cria o composer.json
cat > $PACKAGE_BASE/composer.json <<EOL
{
    "name": "$VENDOR/$PACKAGE",
    "description": "Componentes Blade para favicon animado e barra de ouvidoria",
    "type": "library",
    "license": "MIT",
    "version": "1.0.0",
    "autoload": {
        "psr-4": {
            "dgti\\\\FaviconAnimado\\\\": "src/"
        }
    },
    "extra": {
        "laravel": {
            "providers": [
                "dgti\\\\FaviconAnimado\\\\FaviconAnimadoServiceProvider"
            ]
        }
    },
    "require": {
        "php": "^8.0",
        "illuminate/support": "^8.0|^9.0|^10.0|^11.0|^12.0"
    }
}
EOL

# Cria um README básico
cat > $PACKAGE_BASE/README.md <<EOL
# $PACKAGE

Componentes Blade para favicon animado e barra de ouvidoria.

## Instalação

Veja o README para instruções de uso.
EOL

# Compacta o package para transporte
cd packages/$VENDOR
tar czf ${PACKAGE}.tar.gz $PACKAGE
cd - > /dev/null

echo "Package criado em $PACKAGE_BASE"
echo "Arquivo compactado gerado em packages/$VENDOR/${PACKAGE}.tar.gz"
