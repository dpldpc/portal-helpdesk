#!/bin/bash

# Definir cores para melhor visualização
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Iniciando limpeza completa do ambiente Docker...${NC}"

# Parar todos os contêineres em execução
echo -e "${YELLOW}Parando todos os contêineres em execução...${NC}"
docker stop $(docker ps -q) 2>/dev/null || echo -e "${RED}Nenhum contêiner em execução${NC}"

# Remover todos os contêineres
echo -e "${YELLOW}Removendo todos os contêineres...${NC}"
docker rm $(docker ps -a -q) 2>/dev/null || echo -e "${RED}Nenhum contêiner para remover${NC}"

# Remover todas as imagens
echo -e "${YELLOW}Removendo todas as imagens...${NC}"
docker rmi $(docker images -q) -f 2>/dev/null || echo -e "${RED}Nenhuma imagem para remover${NC}"

# Remover todos os volumes
echo -e "${YELLOW}Removendo todos os volumes...${NC}"
docker volume rm $(docker volume ls -q) 2>/dev/null || echo -e "${RED}Nenhum volume para remover${NC}"

# Remover redes não utilizadas (exceto as padrão)
echo -e "${YELLOW}Removendo redes não utilizadas...${NC}"
docker network prune -f

# Limpar sistema (remove contêineres parados, redes não utilizadas, imagens sem tags e cache de build)
echo -e "${YELLOW}Executando limpeza do sistema...${NC}"
docker system prune -a -f --volumes

echo -e "${GREEN}Limpeza do ambiente Docker concluída!${NC}"
echo -e "${GREEN}Todas as imagens, contêineres, volumes e redes foram removidos.${NC}"