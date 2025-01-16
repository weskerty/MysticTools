#!/bin/bash
pkg install -y tur-repo x11-repo
pkg install wget -y
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/.bashrc > ~/.bashrc 
  apt-get update
apt-get install nano gcc clang make wget curl git ffmpeg nodejs-lts pkg-config 
  wget https://github.com/lzhiyong/termux-ndk/releases/download/android-ndk/android-ndk-r27b-aarch64.zip 
  unzip ~/android-ndk-r27b-aarch64.zip -d ~/android-ndk
  wget  https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/lev.sh -O ~/lev.sh 
    wget  https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/include.gypi -O ~/.gyp/include.gypi 
  chmod +x ~/lev.sh 
  git clone https://github.com/lyfe00011/levanter.git levanter
  wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/config.env -O ~/levanter/config.env 
  

  
  npm install yarn pm2 -g 
  cd levanter 
  yarn install 

  # Preguntar por SESSION_ID
  echo -e '\e[36mDo you have a SESSION_ID scanned today? (y/n):\e[0m' && \
  read -r HAS_SESSION_ID && \
  if [[ \"\$HAS_SESSION_ID\" == \"y\" ]]; then \
    echo -e '\e[36mEnter Your SESSION_ID:\e[0m' && \
    read -r SESSION_ID && \
    echo \"SESSION_ID=\$SESSION_ID\" >> ~/levanter/config.env; \
  fi && \
  
  npm start 
