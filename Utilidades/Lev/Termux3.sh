#!/bin/bash

# Instalar repositorio de Comunidad
pkg install -y tur-repo x11-repo

# Actualizar Repositorio
apt-get update

# Instalar Programas Necesarios
pkg install -y wget nano clang make git ffmpeg nodejs-lts pkg-config

# Agregar .bashrc para Inicio Automatico al Abrir Termux
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/.bashrc -O ~/.bashrc

# Descargar lzhiyongAndroidNDK, necesario para que gyp compilale sqlite3, el cual utiliza Levanter.
wget https://github.com/lzhiyong/termux-ndk/releases/download/android-ndk/android-ndk-r27b-aarch64.zip -O ~/android-ndk.zip
unzip ~/android-ndk.zip -d ~/android-ndk
rm ~/android-ndk.zip

# Descargar include.gypi.Informa donde esta AndroidNDK
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/include.gypi -O ~/.gyp/include.gypi

# Descarga lev.sh. Script de Inicio del Bot
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/lev.sh -O ~/lev.sh

chmod +x ~/lev.sh

# Clon Repo Levanter
git clone https://github.com/lyfe00011/levanter.git ~/levanter

# Descargar config.env Especifico.
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/config.env -O ~/levanter/config.env

# Instalar Yarn y PM2 Requeridos por Levanter.
npm install -g yarn
yarn global add pm2

# Instalar Levanter
cd ~/levanter || exit
yarn install

# Preguntar por SESSION_ID
echo -e "\e[36mDo you have a SESSION_ID scanned today? (y/n):\e[0m"
read -r HAS_SESSION_ID

if [[ "$HAS_SESSION_ID" == "y" ]]; then
  echo -e "\e[36mEnter Your SESSION_ID:\e[0m"
  read -r SESSION_ID
  echo "SESSION_ID=$SESSION_ID" >> ~/levanter/config.env
fi

# Iniciar Levanter
npm start
