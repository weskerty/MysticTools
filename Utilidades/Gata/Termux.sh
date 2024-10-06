#!/bin/bash
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/.bashrc -O ~/.bashrc
proot-distro login debian -- bash -c "
  apt-get update && \ 
  curl -fsSL https://deb.nodesource.com/setup_current.x -o nodesource_setup.sh && \
  bash nodesource_setup.sh
  apt-get install gcc make wget curl git ffmpeg imagemagick python3 python3-pip nodejs -y && \
  wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/update.sh -O ~/update.sh && \
  mkdir -p ~/script && wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/mystic.sh -O ~/script/mystic.sh && \
  wget  https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/alive.sh -O ~/alive.sh && \
  chmod +x ~/update.sh && \
  chmod +x ~/script/mystic.sh && \
  chmod +x ~/alive.sh && \
  git clone https://github.com/BrunoSobrino/TheMystic-Bot-MD.git mystic && \
  cd mystic && \
  npm install --force && \
  npm start code
"
