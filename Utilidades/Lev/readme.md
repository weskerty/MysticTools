delete termux and install termux here: https://github.com/termux/termux-app/releases/download/v0.119.0-beta.1/termux-app_v0.119.0-beta.1+apt-android-7-github-debug_universal.apk

install termux and all permision, storage notification, allow run in background etc
open termux
activate wakelock on notification 

paste in termux:

apt update -y && yes | apt upgrade && pkg install -y wget proot-distro && proot-distro install debian && wget -O - https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/Termux.sh | bash