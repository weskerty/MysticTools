#!/bin/bash
pkg install -y proot-distro && proot-distro install debian && \
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/.bashrc -O ~/.bashrc
proot-distro login debian -- bash -c "
  apt-get update && \ 
  curl -fsSL https://deb.nodesource.com/setup_lts.x -o nodesource_setup.sh && \
  bash nodesource_setup.sh
  apt-get install sudo nano gcc make wget curl git ffmpeg nodejs yarn -y && \
  wget  https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/lev.sh -O ~/lev.sh && \
  chmod +x ~/lev.sh && \
  git clone https://github.com/lyfe00011/levanter.git levanter && \
  wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/.bashrc -O ~/levanter/config.env && \
  cd levanter && \
  nano config.env && \
  yarn install && \
  npm start 
"

#RUN in TERMUX: apt update -y && yes | apt upgrade && pkg install -y wget && wget -O - https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/Termux.sh | bash 