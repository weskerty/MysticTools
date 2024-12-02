#!/bin/bash
pkg install -y proot-distro && proot-distro install debian && \
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/.bashrc -O ~/.bashrc && \
proot-distro login debian -- bash -c "
  apt-get update && \ 
  curl -fsSL https://deb.nodesource.com/setup_lts.x -o nodesource_setup.sh && \
  bash nodesource_setup.sh && \
  apt-get install sudo nano gcc make wget curl git ffmpeg nodejs -y && \
  wget  https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/lev.sh -O ~/lev.sh && \
  chmod +x ~/lev.sh && \
  git clone https://github.com/lyfe00011/levanter.git levanter && \
  wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/config.env -O ~/levanter/config.env && \
  
  # Preguntar por SESSION_ID
  echo -e '\e[36mDo you have a SESSION_ID scanned today? (y/n):\e[0m' && \
  read -r HAS_SESSION_ID && \
  if [[ \"\$HAS_SESSION_ID\" == \"y\" ]]; then \
    echo -e '\e[36mEnter Your SESSION_ID:\e[0m' && \
    read -r SESSION_ID && \
    echo \"SESSION_ID=\$SESSION_ID\" >> ~/levanter/config.env; \
  fi && \
  
  npm install yarn pm2 -g && \
  cd levanter && \
  yarn install && \
  npm start 
"
