#!/bin/bash


#Actualizador e Iniciador de Script Mantenedores.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

#echo -e "${YELLOW}######### Actualizando Sistema...${NC}"
#pacman -Syu --noconfirm
#apt-get update && apt-get upgrade -y

cd "$HOME/mystic/" || { echo -e "${RED}######### Error. No existe Mystic.${NC}"; exit 1; }

echo -e "${YELLOW}######### Comprobando Actualizacion...${NC}"
git_output=$(git pull https://github.com/GataNina-Li/GataBot-MD.git)

if [[ "$git_output" == *"Already up to date."* ]]; then
    echo -e "${GREEN}######### Ya Actualizado.${NC}"
else
    echo -e "${YELLOW}######### Actualizando${NC}"
    
    npm install || { echo -e "${RED}######### Error en NPM INSTALL.${NC}"; }
        
    echo -e "${GREEN}######### Actualizacion Completa.${NC}"
fi

cd "$HOME" || { echo -e "${RED}######### Error en cd Home.${NC}"; exit 1; }

echo -e "${YELLOW}######### Ejecutando Mystic...${NC}"
./alive.sh || { echo -e "${RED}######### Error al Iniciar Alives Script.${NC}"; exit 1; }
