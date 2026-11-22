#!/data/data/com.termux/files/usr/bin/bash
# curl -sL https://raw.githubusercontent.com/weskerty/MysticTools/main/Utilidades/Lev/Termux2.sh | bash

main() {
G='\e[1;32m'; Y='\e[1;33m'; C='\e[1;36m'; M='\e[1;35m'; R='\e[1;31m'; N='\e[0m'

ask() {
  local __var=$1 __ans=""
  if [ -t 0 ]; then
    read -r __ans
  elif [ -r /dev/tty ] && { true </dev/tty; } 2>/dev/null; then
    read -r __ans </dev/tty
  fi
  printf -v "$__var" '%s' "$__ans"
}

export DEBIAN_FRONTEND=noninteractive
APT_OPTS=(-y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold)

fix_apt() {
  dpkg --configure -a </dev/null
  apt-get "${APT_OPTS[@]}" -f install </dev/null
}

echo -e "${C}┌─────────────────────────────────┐${N}"
echo -e "${C}│ 🚀 Levanter Termux Installer    │${N}"
echo -e "${C}└─────────────────────────────────┘${N}"
echo -e "${Y}ACEPTA LOS PERMISOS CUANDO APAREZCAN | ACCEPT PERMISSIONS WHEN THEY APPEAR${N}"
sleep 3
if [ ! -d ~/storage ]; then
  termux-setup-storage </dev/null
  sleep 3
fi
termux-wake-lock 2>/dev/null

echo -e "${G}Actualizando repositorios...${N}"
fix_apt
if ! { apt-get update </dev/null && apt-get "${APT_OPTS[@]}" full-upgrade </dev/null; }; then
  echo -e "${Y}Reintentando actualizacion...${N}"
  fix_apt
  apt-get update </dev/null
  apt-get "${APT_OPTS[@]}" full-upgrade </dev/null || { echo -e "${R}Fallo la actualizacion de paquetes.${N}"; exit 1; }
fi

echo -e "${G}Instalando dependencias...${N}"
PKGS=(python nodejs-lts git ffmpeg yarn build-essential pkg-config python-pip libxml2 libxslt libvips)
if ! apt-get "${APT_OPTS[@]}" install "${PKGS[@]}" </dev/null; then
  fix_apt
  apt-get "${APT_OPTS[@]}" install "${PKGS[@]}" </dev/null || { echo -e "${R}Fallo la instalacion de dependencias.${N}"; exit 1; }
fi
pip install setuptools </dev/null || { echo -e "${R}Fallo pip install setuptools.${N}"; exit 1; }

echo -e "${G}Configurando node-gyp para Termux (sin NDK)...${N}"
mkdir -p ~/.gyp
echo "{ 'variables': { 'android_ndk_path': '' } }" > ~/.gyp/include.gypi
export GYP_DEFINES="android_ndk_path=''"

echo -e "${G}Instalando PM2...${N}"
yarn global add pm2 </dev/null

echo -e "${G}Clonando Levanter...${N}"
if [ -d ~/levanter/.git ]; then
  git -C ~/levanter pull --ff-only </dev/null
else
  rm -rf ~/levanter
  git clone https://github.com/lyfe00011/levanter.git ~/levanter </dev/null || exit 1
fi
cd ~/levanter || exit 1

echo -e "${G}Instalando dependencias de Levanter...${N}"
yarn install --network-timeout 600000 </dev/null || { echo -e "${R}Fallo yarn install.${N}"; exit 1; }

cat > config.env << 'EOF'
SESSION_ID = ""
SUDO = ""
FORCE_LOGOUT = "false"
VPS = "true"
DISABLE_START_MESSAGE = "false"
PREFIX = "."
STICKER_PACKNAME = "by LyFE"
ALWAYS_ONLINE = "true"
WARN_LIMIT = "3"
MAX_UPLOAD = "1900"
REJECT_CALL = "false"
TZ = "America/Asuncion"
AUTO_STATUS_VIEW = "false"
SEND_READ = "false"
AJOIN = "false"
LIST_TYPE = "list"
CMD_REACTION = "true"
ANTIWORDS = "kill,pilin"
WARN_MESSAGE = "> i _&mention Warn_"
WARN_RESET_MESSAGE = "> i _&mention warn reset_"
WARN_KICK_MESSAGE = "> i _&mention Fuiste Temporalmente Suspendido por incumplir las Normas._"
ANTILINK_MSG = "> i _&mention El Spam no se Tolera Aqui. Respeta las Reglas._"
ANTISPAM_MSG = "> i _&mention Fuiste Temporalmente Suspendido por Flood._"
ANTIWORDS_MSG = "> i _&mention no word"
PERSONAL_MESSAGE = "null"
EOF

echo -e "${M}¿Tienes tu SESSION_ID? (y/n):${N}"
ask HAS_SID
if [[ "$HAS_SID" == [yYsS]* ]]; then
  echo -e "${M}Pega tu SESSION_ID y presiona Enter:${N}"
  ask SID
  SID=$(printf '%s' "$SID" | tr -d '\r' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
  if [ -n "$SID" ]; then
    SID_ESC=$(printf '%s' "$SID" | sed 's/[\\|&]/\\&/g')
    sed -i "s|^SESSION_ID = \"\"|SESSION_ID = \"$SID_ESC\"|" config.env
  fi
fi

echo -e "${G}Configurando autoinicio...${N}"
cat > ~/.bashrc << 'EOF'
termux-wake-lock 2>/dev/null
export GYP_DEFINES="android_ndk_path=''"

if [[ $- == *i* ]] && [ -z "$SSH_CONNECTION" ] && [ -d ~/levanter ]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

  echo -e "${YELLOW}Presiona una tecla para evitar el inicio automatico...${NC}"
  timeout=5
  cancelled=0
  while [ $timeout -gt 0 ]; do
    echo -ne "${YELLOW}Iniciando en $timeout segundos...\r${NC}"
    if read -t 1 -n 1 -s keypress; then
      cancelled=1
      break
    fi
    timeout=$((timeout - 1))
  done

  if [ $cancelled -eq 1 ]; then
    echo -e "\n${RED}Inicio automatico cancelado.${NC}"
    echo -e "${GREEN}Puedes usar Termux normalmente.${NC}"
    echo -e "Ir a la carpeta del bot: ${YELLOW}cd levanter${NC}"
    echo -e "Editar config: ${YELLOW}nano config.env${NC} (Ctrl+O guardar, Ctrl+X salir)"
  else
    echo -e "\n${GREEN}Iniciando Bot...${NC}"
    cd ~/levanter && yarn start
  fi
fi
EOF

echo -e "${G}Listo. Iniciando bot ahora...${N}"
if [ -t 0 ] || [ ! -r /dev/tty ]; then
  yarn start
else
  yarn start </dev/tty
fi
}

main "$@"
