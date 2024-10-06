#!/bin/bash
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Gata/.bashrc -O ~/.bashrc
proot-distro login debian -- bash -c "
  apt-get update && \ 
  curl -fsSL https://deb.nodesource.com/setup_current.x -o nodesource_setup.sh && \
  bash nodesource_setup.sh
  apt-get install gcc make wget curl git ffmpeg imagemagick python3 python3-pip nodejs -y && \
  wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Gataupdate.sh -O ~/update.sh && \
  mkdir -p ~/script && wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Gata/gata.sh -O ~/script/gata.sh && \
  wget  https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Gata/alive.sh -O ~/alive.sh && \
  chmod +x ~/update.sh && \
  chmod +x ~/script/gata.sh && \
  chmod +x ~/alive.sh && \
  git clone https://github.com/GataNina-Li/GataBot-MD.git gata && \
  cd gata && \
  npm install --force && \
  npm start code
"
