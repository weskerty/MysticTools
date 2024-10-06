#!/bin/bash
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/.bashrc -O ~/.bashrc
proot-distro login debian -- bash -c "
  apt-get update && \ 
  curl -fsSL https://deb.nodesource.com/setup_lts.x -o nodesource_setup.sh && \
  bash nodesource_setup.sh
  apt-get install gcc make wget curl git ffmpeg imagemagick python3 python3-pip nodejs -y && \
  npm install -g yarn pm2 && \
  wget  https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/lev.sh -O ~/lev.sh && \
  chmod +x ~/lev.sh && \
  git clone https://github.com/lyfe00011/levanter.git levanter && \
  cd levanter && \
  yarn install && \
  npm start 
"
