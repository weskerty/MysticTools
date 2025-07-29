#!/bin/bash
# Presentacion
echo -e "\e[1;36m┌─────────────────────────────────┐\e[0m"
echo -e "\e[1;36m│ \e[1;32m🚀 Levanter Termux Installer \e[1;36m│\e[0m"
echo -e "\e[1;36m└─────────────────────────────────┘\e[0m"
echo -e "\e[1;33m⚠️ ACEPTA LOS PERMISOS CUANDO APAREZCAN | ACCEPT PERMISSIONS WHEN THEY APPEAR \e[0m"
echo -e "\e[1;33m⚠️ CONCEDE PERMISOS DE ALMACENAMIENTO Y EJECUCION | GRANT STORAGE AND EXECUTION PERMISSIONS \e[0m"
sleep 5
echo -e "\e[1;32m🔧 Solicitando Permisos... | Requesting Permissions...\e[0m"
echo 
termux-setup-storage
sleep 7
termux-wake-lock
echo -e "\e[1;32m📦 Actualizando repositorios... | Updating repositories...\e[0m"
apt-get update &&
echo -e "\e[1;32m📋 Instalando repositorio de comunidad... | Installing community repository...\e[0m"
pkg install -y tur-repo x11-repo && \
echo -e "\e[1;32m🔄 Actualizando repositorio... | Updating repository...\e[0m"
apt-get update && \
echo -e "\e[1;32m⚙️ Instalando programitas necesarios... | Installing necessary programs...\e[0m"
pkg install -y python nano clang make git ffmpeg nodejs-lts pkg-config libxml2 libxslt matplotlib xorgproto rust binutils wget build-essential libvips python-pip glib openjdk-21 file libsqlite sqlite && \
echo -e "\e[1;32m🐍 Instalando dependencias de Python... | Installing Python dependencies...\e[0m"
pip install cython wheel setuptools python-dotenv && \
echo -e "\e[1;32m🌍 Configurando variables de entorno... | Setting up environment variables...\e[0m"
export ANDROID_NDK_HOME=~/android-ndk/android-ndk-r27b && \
export PATH=$ANDROID_NDK_HOME:$PATH && \
echo -e "\e[1;32m📁 Creando directorios necesarios... | Creating necessary directories...\e[0m"
mkdir -p ~/.gyp && \
mkdir -p ~/android-ndk && \
mkdir -p ~/levanter && \
echo -e "\e[1;32m🔧 Configurando .bashrc para inicio automático... | Setting up .bashrc for automatic startup...\e[0m"
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/.bashrc -o ~/.bashrc && \
echo -e "\e[1;32m⬇️ Descargando Android NDK... | Downloading Android NDK...\e[0m"
curl -fsSL https://github.com/lzhiyong/termux-ndk/releases/download/android-ndk/android-ndk-r27b-aarch64.zip -o ~/android-ndk.zip && \
echo -e "\e[1;32m📂 Descomprimiendo Android NDK... | Extracting Android NDK...\e[0m"
unzip ~/android-ndk.zip -d ~/android-ndk && \
rm ~/android-ndk.zip && \
echo -e "\e[1;32m📋 Descargando archivo de configuración gyp... | Downloading gyp configuration file...\e[0m"
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/include.gypi -o ~/.gyp/include.gypi && \
echo -e "\e[1;32m📜 Descargando script de inicio del bot... | Downloading bot startup script...\e[0m"
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/lev.sh -o ~/lev.sh && \
echo -e "\e[1;32m🔐 Asignando permisos de ejecución... | Assigning execution permissions...\e[0m"
chmod +x ~/lev.sh && \
echo -e "\e[1;32m🔽 Clonando repositorio de Levanter... | Cloning Levanter repository...\e[0m"
git clone https://github.com/lyfe00011/levanter.git ~/levanter && \
echo -e "\e[1;32m⚙️ Descargando configuración específica... | Downloading specific configuration...\e[0m"
curl -fsSL https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/config.env -o ~/levanter/config.env && \
echo -e "\e[1;32m📦 Instalando Yarn y PM2... | Installing Yarn and PM2...\e[0m"
npm install -g yarn && \
yarn global add pm2 && \
echo -e "\e[1;32m🔧 Instalando dependencias de Levanter... | Installing Levanter dependencies...\e[0m"
cd ~/levanter && \
yarn install && \
echo -e "\e[1;35m❓ ¿Tienes tu SESSION_ID? | Do you have a SESSION_ID? (y/n):\e[0m" && \
read -r HAS_SESSION_ID && \
if [[ "$HAS_SESSION_ID" == "y" ]]; then
  echo -e "\e[1;35m🔑 Ingresa tu SESSION_ID | Enter Your SESSION_ID:\e[0m" && \
  read -r SESSION_ID && \
  echo "SESSION_ID=$SESSION_ID" >> ~/levanter/config.env
fi && \
echo -e "\e[1;32m🎉 ¡Todo listo! Iniciando... | Starting...\e[0m"
npm start
