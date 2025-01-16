#!/bin/bash

# Instalar repositorio de Comunidad
pkg install -y tur-repo x11-repo && \
# Actualizar Repositorio
apt-get update && \
# Instalar Programas ""Necesarios"". No recuerdo cual es la dependencia necesaria, algun dia vere cuales estan de mas.
pkg install -ypython nano clang make git ffmpeg nodejs-lts pkg-config libxml2 libxslt matplotlib xorgproto rust binutils wget build-essential libvips python-pip glib openjdk-21 file libsqlite sqlite && \
pip install cython wheel setuptools python-dotenv && \
# Crear directorios necesarios
mkdir -p ~/.gyp && \
mkdir -p ~/android-ndk && \
mkdir -p ~/levanter && \
# Agregar .bashrc para Inicio Automático al Abrir Termux
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/.bashrc -o ~/.bashrc && \
# Descargar lzhiyongAndroidNDK, necesario para que gyp compile sqlite3, el cual utiliza Levanter
curl -fsSL https://github.com/lzhiyong/termux-ndk/releases/download/android-ndk/android-ndk-r27b-aarch64.zip -o ~/android-ndk.zip && \
unzip ~/android-ndk.zip -d ~/android-ndk && \
rm ~/android-ndk.zip && \
# Descargar include.gypi. Informa donde está AndroidNDK
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/include.gypi -o ~/.gyp/include.gypi && \
# Descargar lev.sh. Script de Inicio del Bot
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/lev.sh -o ~/lev.sh && \
chmod +x ~/lev.sh && \
# Clonar Repo Levanter
git clone https://github.com/lyfe00011/levanter.git ~/levanter && \
# Descargar config.env específico
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/config.env -o ~/levanter/config.env && \
# Instalar Yarn y PM2 requeridos por Levanter
npm install -g yarn && \
yarn global add pm2 && \
# Instalar dependencias de Levanter
cd ~/levanter && \
yarn install && \
# Preguntar por SESSION_ID
echo -e "\e[36mDo you have a SESSION_ID scanned today? (y/n):\e[0m" && \
read -r HAS_SESSION_ID && \
if [[ "$HAS_SESSION_ID" == "y" ]]; then
  echo -e "\e[36mEnter Your SESSION_ID:\e[0m" && \
  read -r SESSION_ID && \
  echo "SESSION_ID=$SESSION_ID" >> ~/levanter/config.env
fi && \
# Iniciar Levanter
npm start
