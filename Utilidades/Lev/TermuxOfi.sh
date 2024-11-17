#!/bin/bash
pkg install -y proot-distro && proot-distro install debian && \
wget https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/.bashrc -O ~/.bashrc && \
proot-distro login debian -- bash -c "
  apt-get update && \ 
  curl -fsSL http://bit.ly/43JqREw -o levOfi.sh && \
  bash evOfi.sh
"

#RUN in TERMUX: apt update -y && yes | apt upgrade && pkg install -y wget && wget -O - https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Utilidades/Lev/TermuxOfi.sh | bash 

# 💡 Prevent Force Close (Optional)
# In case Termux keeps closing on you, try this. It's better to do it Command by Command, but Copying and Pasting Everything Should Work Too.

# On some phones, the "Disable Child Process Restrictions" option appears in Developer Options
# You can do this process from your PC or from Termux itself by following this tutorial https://gist.github.com/kairusds/1d4e32d3cf0d6ca44dc126c1a383a48d
