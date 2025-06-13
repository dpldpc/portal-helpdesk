#!/bin/bash

# Verifica se o script está sendo executado dentro de um repositório Git
if [ ! -d .git ]; then
    echo "Erro: Este diretório não é um repositório Git."
    exit 1
fi

# Verifica se git-flow está instalado
if ! command -v git-flow &> /dev/null; then
    echo "Erro: git-flow não está instalado."
    echo "Instale com: sudo apt install git-flow (Debian/Ubuntu) ou brew install git-flow (macOS)"
    exit 1
fi

echo "Inicializando git-flow..."

# Configuração automática do git-flow
git flow init -d

echo "Git-flow configurado com sucesso!"

