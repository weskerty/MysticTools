#!/bin/bash
proot-distro login debian -- bash -c "
cd levanter
  # Preguntar por SESSION_ID
  echo -e '\e[36mDo you have a SESSION_ID scanned today? (y/n):\e[0m' && \
  read -r HAS_SESSION_ID && \
  if [[ \"\$HAS_SESSION_ID\" == \"y\" ]]; then \
    echo -e '\e[36mEnter Your SESSION_ID:\e[0m' && \
    read -r SESSION_ID && \
    echo \"SESSION_ID=\$SESSION_ID\" >> ~/levanter/config.env; \
  else \
    sed -i '/^SESSION_ID=/d' ~/levanter/config.env; \
  fi && \
  npm start 
"
