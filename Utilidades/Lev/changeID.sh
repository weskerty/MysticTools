#!/bin/bash
#proot-distro login debian 
bash -c "
cd levanter && \
  # Preguntar por SESSION_ID
  echo -e '\e[36mDo you have a SESSION_ID scanned today? (y/n):\e[0m' && \
  read -r HAS_SESSION_ID && \
  if [[ \"\$HAS_SESSION_ID\" == \"y\" || \"\$HAS_SESSION_ID\" == \"Y\" ]]; then \
    echo -e '\e[36mEnter Your SESSION_ID:\e[0m' && \
    read -r SESSION_ID && \
    sed -i '/^SESSION_ID=/d' ~/levanter/config.env && \
    echo \"SESSION_ID=\$SESSION_ID\" >> ~/levanter/config.env && \
    echo -e '\e[32mSESSION_ID added successfully!\e[0m'; \
  else \
    sed -i '/^SESSION_ID=/d' ~/levanter/config.env && \
    echo -e '\e[33mSESSION_ID removed from config.env\e[0m'; \
  fi && \
  echo -e '\e[36mStarting application...\e[0m' && \
  npm start 
"
