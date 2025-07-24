#!/bin/bash

# Persmisos Termux
termux-setup-storage
termux-wake-lock
apt-get update &&
# Instalar repositorio de Comunidad
pkg install -y tur-repo x11-repo && \
# Actualizar Repositorio
apt-get update && \
# Instalar Programas ""Necesarios"". No recuerdo cual es la dependencia necesaria, algun dia vere cuales estan de mas.
pkg install -y python nano clang make git ffmpeg nodejs-lts pkg-config libxml2 libxslt matplotlib xorgproto rust imagemagick binutils wget build-essential libvips python-pip glib openjdk-21 file libsqlite sqlite && \
pip install cython wheel setuptools python-dotenv && \
export ANDROID_NDK_HOME=~/android-ndk/android-ndk-r27b && \
export PATH=$ANDROID_NDK_HOME:$PATH && \
# Crear directorios necesarios
mkdir -p ~/.gyp && \
mkdir -p ~/android-ndk && \
# Descargar lzhiyongAndroidNDK, necesario para que gyp compile sqlite3
curl -fsSL https://github.com/lzhiyong/termux-ndk/releases/download/android-ndk/android-ndk-r27b-aarch64.zip -o ~/android-ndk.zip && \
unzip ~/android-ndk.zip -d ~/android-ndk && \
rm ~/android-ndk.zip && \
# Descargar include.gypi. Informa donde está AndroidNDK
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/include.gypi -o ~/.gyp/include.gypi && \







# Agregar .bashrc para Inicio Automático al Abrir Termux
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/MysticBS/.bashrc -o ~/.bashrc && \
# Script Actualizacion 
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/MysticBS/update.sh -O ~/update.sh && \
# Descargar Script de Inicio del Bot
mkdir -p ~/script && curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/MysticBS/mystic.sh -O ~/script/mystic.sh && \
# Script KAlive
curl -fsSL  https://raw.githubusercontent.com/weskerty/AlwaysRun/refs/heads/main/all.sh -O ~/alive.sh && \
#Permisos Ejecucion
chmod +x ~/update.sh && \
chmod +x ~/script/mystic.sh && \
chmod +x ~/alive.sh && \

# Clonar Repo 
git clone https://github.com/BrunoSobrino/TheMystic-Bot-MD.git mystic && \

# Instalar dependencias
cd ~/mystic && \
npm install --force  && \

# Iniciar 
npm start
