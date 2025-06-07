#!/bin/bash
echo "===== DOCKER RECURSOS EXISTENTES ====="
echo ""
echo "----- CONTÊINERES -----"
docker ps -a
echo ""
echo "----- IMAGENS -----"
docker images -a
echo ""
echo "----- VOLUMES -----"
docker volume ls
echo ""
echo "----- REDES -----"
docker network ls
echo ""
echo "----- USO DE DISCO DO DOCKER -----"
docker system df