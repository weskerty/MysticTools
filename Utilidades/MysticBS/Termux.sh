#!/bin/bash

# Presentacion
echo -e "\e[1;36m┌────────────────────────────┐\e[0m"
echo -e "\e[1;36m│ \e[1;32m🔮 Mystic Termux Installer \e[1;36m│\e[0m"
echo -e "\e[1;36m└────────────────────────────┘\e[0m"

echo -e "\e[1;33m⚠️ ACEPTA LOS PERMISOS CUANDO APAREZCAN \e[0m"
echo -e "\e[1;33m⚠️ CONCEDE PERMISOS DE ALMACENAMIENTO Y EJECUCION \e[0m"
sleep 5

echo -e "\e[1;32m🔧 Configurando permisos de Termux...\e[0m"
echo 
termux-setup-storage
sleep 7
termux-wake-lock

echo -e "\e[1;32m📦 Actualizando repositorios...\e[0m"
pkg update &&

echo -e "\e[1;32m📋 Instalando repositorio de comunidad...\e[0m"
pkg install -y tur-repo x11-repo && \

echo -e "\e[1;32m🔄 Actualizando repositorio...\e[0m"
pkg update && yes "Y" | pkg upgrade && \

echo -e "\e[1;32m⚙️ Instalando programitas...\e[0m"
pkg install -y python nano clang make git ffmpeg nodejs-lts pkg-config libxml2 libxslt matplotlib xorgproto rust imagemagick binutils wget build-essential libvips python-pip glib openjdk-21 file libsqlite sqlite && \

echo -e "\e[1;32m🐍 Instalando dependencias de Python...\e[0m"
pip install cython wheel setuptools python-dotenv && \

echo -e "\e[1;32m🌍 Configurando variables de entorno...\e[0m"
export ANDROID_NDK_HOME=~/android-ndk/android-ndk-r27b && \
export PATH=$ANDROID_NDK_HOME:$PATH && \

echo -e "\e[1;32m📁 Creando directorios...\e[0m"
mkdir -p ~/.gyp && \
mkdir -p ~/android-ndk && \

echo -e "\e[1;32m⬇️ Descargando Android NDK...\e[0m"
curl -fSL https://github.com/lzhiyong/termux-ndk/releases/download/android-ndk/android-ndk-r27b-aarch64.zip -o ~/android-ndk.zip && \

echo -e "\e[1;32m📂 Descomprimiendo Android NDK...\e[0m"
unzip ~/android-ndk.zip -d ~/android-ndk && \
rm ~/android-ndk.zip && \

echo -e "\e[1;32m📋 Descargando archivo de configuracion gyp...\e[0m"
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/include.gypi -o ~/.gyp/include.gypi && \

echo -e "\e[1;32m🚀 Configurando .bashrc para inicio automático...\e[0m"
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/MysticBS/.bashrc -o ~/.bashrc && \

echo -e "\e[1;32m🔄 Descargando script de actualización...\e[0m"
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/MysticBS/update.sh -o ~/update.sh && \

echo -e "\e[1;32m📜 Descargando script de inicio del bot...\e[0m"
mkdir -p ~/script && curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/MysticBS/mystic.sh -o ~/script/mystic.sh && \

echo -e "\e[1;32m⏰ Descargando script KAlive...\e[0m"
curl -fsSL https://raw.githubusercontent.com/weskerty/AlwaysRun/refs/heads/main/all.sh -o ~/alive.sh && \

echo -e "\e[1;32m🔐 Asignando permisos de ejecución...\e[0m"
chmod +x ~/update.sh && \
chmod +x ~/script/mystic.sh && \
chmod +x ~/alive.sh && \

echo -e "\e[1;32m🔽 Clonando repositorio del bot...\e[0m"
git clone https://github.com/BrunoSobrino/TheMystic-Bot-MD.git mystic && \

echo -e "\e[1;32m📦 Instalando dependencias del bot...\e[0m"
cd ~/mystic && \
npm install --force  && \

echo -e "\e[1;32m🎉 ¡Todo listo! Iniciando bot...\e[0m"
npm start
