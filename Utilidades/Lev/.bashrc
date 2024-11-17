termux-wake-lock

# Colores mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

echo -e "${YELLOW}Presiona una Tecla para Evitar el Inicio Automatico...${NC}"

timeout=5  

while [ $timeout -gt 0 ]; do
    echo -ne "${YELLOW}Iniciando en $timeout segundos...\r${NC}"
    
    read -t 1 -n 1 keypress
    
    if [ $? -eq 0 ]; then
        echo -e "\n${RED}Inicio Automatico Cancelado.${NC}"
        
        echo -e "${GREEN}Puedes Utilizar Termux Normalmente.${NC}"
        echo -e "El bot esta en un Contenedor, Utiliza el Comando ${YELLOW}proot-distro login debian${NC} para Ingresar."
        echo -e "${GREEN}Comandos Utiles:${NC}"
        echo -e "${YELLOW}ls${NC} Visor de Archivos. ${YELLOW}cd${NC} NAvegador de Archivos. ${YELLOW}nano${NC} Creador y Editor de Texto. ${YELLOW}mkdir${NC} Creador de Carpetas/Directorios ${YELLOW}rm${NC} Borrar Archivos. Cada uno de estos Comandos se puede usar junto con ${YELLOW}--help para ver sus Funciones"
        echo -e "${GREEN}Ejemplo:${NC}"
        echo -e "Ir a la Carpeta del bot: ${YELLOW}cd levanter ${NC}"
        echo -e "Editar la Configuracion de Levanter: ${YELLOW}nano config.env ${NC}con Ctrl+O Guardas, Enter y Ctrl+X Salir de Nano."
        echo -e "${GREEN} ¿Necesitas Ayuda? Contacta con Nosotros en Telegram @LevanterLyfe ${NC}"
        echo -e "${RED} English ${NC}"
        echo -e "\n${RED}Autostart Canceled.${NC}"
        echo -e "${GREEN}You can use Termux normally.${NC}"
        echo -e "The bot is in a container, use the command ${YELLOW}proot-distro login debian${NC} to log in."
        echo -e "${GREEN}Useful Commands:${NC}"
        echo -e "${YELLOW}ls${NC} File Viewer. ${YELLOW}cd${NC} File Browser. ${YELLOW}nano${NC} Text Creator and Editor. ${YELLOW}mkdir${NC} Folder/Directory Creator ${YELLOW}rm${NC} Delete Files. Each of these commands can be used in conjunction with ${YELLOW}--help to see their Functions"
        echo -e "${GREEN}Example:${NC}"
        echo -e "Go to Bot Folder: ${YELLOW}cd levanter ${NC}"
        echo -e "Editing the Levanter Configuration: ${YELLOW}nano config.env ${NC}with Ctrl+O Save, Enter and Ctrl+X Exit Nano."
        echo -e "${GREEN} Need Help? Contact Us on Telegram @LevanterLyfe ${NC}"
        return 0  
    fi
    
    timeout=$((timeout - 1))
done

echo -e "\n${GREEN}Iniciando Bot...${NC}"

proot-distro login debian -- /bin/bash -c ./lev.sh