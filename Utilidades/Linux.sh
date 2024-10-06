#!/bin/bash

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Error Sistema"
    exit 1
fi

install_debian() {
    echo "Usando APT..."
    curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
    sudo -E bash nodesource_setup.sh
    sudo apt-get -y install gcc make wget curl git ffmpeg imagemagick python3 python3-pip nodejs
}

install_arch() {
    echo "Usando PACMAN..."
    sudo pacman -Sy --noconfirm gcc make wget curl git ffmpeg imagemagick python python-pip nodejs npm
}

install_fedora() {
    echo "Usando DNF (No Probado)..."
    sudo dnf -y install gcc make wget curl git ffmpeg ImageMagick python3 python3-pip nodejs npm
}

case "$OS" in
    debian|ubuntu)
        install_debian
        ;;
    arch|manjaro)
        install_arch
        ;;
    fedora)
        install_fedora
        ;;
    *)
        echo "El Script no esta Adaptado para $OS. Instalalo Manualmente"
        exit 1
        ;;
esac

echo "Descargando MysticBot..."

wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/update.sh -O ~/update.sh && \
mkdir -p ~/script && wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/mystic.sh -O ~/script/mystic.sh && \
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/alive.sh -O ~/alive.sh && \
chmod +x ~/update.sh ~/script/mystic.sh ~/alive.sh && \
chmod +x ~/update.sh && \
chmod +x ~/script/mystic.sh && \
git clone https://github.com/weskerty/TheMysticMOD.git mystic && \
cd mystic && \
npm install --force && \
npm start qr

