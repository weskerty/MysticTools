#!/bin/bash

# Check if apt package manager is available
if ! command -v apt &> /dev/null; then
    echo -e "\e[31mThis script is intended for use on Linux systems with the apt package manager.\e[0m"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# Function to run commands with sudo if not root
run_with_sudo() {
    if [ "$EUID" -ne 0 ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# Prompt for BOT name
echo -e "\e[36mEnter a name for BOT (e.g., levanter):\e[0m"
read -r BOT_NAME
BOT_NAME=${BOT_NAME:-levanter}

# Handle existing directory with the same name
if [ -d "$BOT_NAME" ]; then
    RANDOM_SUFFIX=$((1 + RANDOM % 1000))
    BOT_NAME="${BOT_NAME}${RANDOM_SUFFIX}"
    echo -e "\e[33mFolder with the same name already exists. Renaming to $BOT_NAME.\e[0m"
fi

# Prompt for SESSION_ID
echo -e "\e[36mDo you have a SESSION_ID scanned today? (y/n):\e[0m"
read -r HAS_SESSION_ID
SESSION_ID=""
if [[ "$HAS_SESSION_ID" == "y" ]]; then
    echo -e "\e[36mEnter Your SESSION_ID:\e[0m"
    read -r SESSION_ID
fi

# Function to install Node.js
install_nodejs() {
    echo -e "\e[33mInstalling Node.js version 20...\e[0m"
    curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
    if ! bash nodesource_setup.sh; then
        echo -e "\e[31mFailed to run nodesource setup script.\e[0m"
        exit 1
    fi
    if ! run_with_sudo apt-get install -y nodejs; then
        echo -e "\e[31mFailed to install Node.js.\e[0m"
        exit 1
    fi
    rm nodesource_setup.sh
}

# Function to uninstall Node.js
uninstall_nodejs() {
    echo -e "\e[33mRemoving existing Node.js installation...\e[0m"
    if ! run_with_sudo apt-get remove -y nodejs; then
        echo -e "\e[31mFailed to remove Node.js.\e[0m"
        exit 1
    fi
    if ! run_with_sudo apt-get autoremove -y; then
        echo -e "\e[31mFailed to autoremove packages.\e[0m"
        exit 1
    fi
}

# Update system packages
echo -e "\e[33mUpdating system packages...\e[0m"
if ! run_with_sudo apt update -y; then
    echo -e "\e[31mFailed to update system packages.\e[0m"
    exit 1
fi

# Install required packages
for pkg in git ffmpeg curl make gcc; do
    if ! command -v "$pkg" &> /dev/null; then
        if ! run_with_sudo apt install -y "$pkg"; then
            echo -e "\e[31mFailed to install $pkg.\e[0m"
            exit 1
        fi
    fi
done

# Check for Node.js version and reinstall if necessary
if command -v node &> /dev/null; then
    CURRENT_NODE_VERSION=$(node -v | cut -d. -f1)
    if [[ "$CURRENT_NODE_VERSION" != "v20" ]]; then
        uninstall_nodejs
        install_nodejs
    else
        echo -e "\e[32mNode.js version 20 is already installed.\e[0m"
    fi
else
    install_nodejs
fi

# Check and install Yarn
YARN_REQUIRED_VERSION="1" # Set required Yarn major version here
if command -v yarn &> /dev/null; then
    CURRENT_YARN_VERSION=$(yarn -v | cut -d. -f1)
    if [[ "$CURRENT_YARN_VERSION" != "$YARN_REQUIRED_VERSION" ]]; then
        echo -e "\e[33mRemoving existing Yarn installation...\e[0m"
        if ! run_with_sudo apt-get remove -y yarn; then
            echo -e "\e[31mFailed to remove Yarn.\e[0m"
            exit 1
        fi
        if ! run_with_sudo apt-get autoremove -y; then
            echo -e "\e[31mFailed to autoremove packages.\e[0m"
            exit 1
        fi
        echo -e "\e[33mInstalling Yarn...\e[0m"
        if ! run_with_sudo npm install -g yarn; then
            echo -e "\e[31mFailed to install Yarn.\e[0m"
            exit 1
        fi
    else
        echo -e "\e[32mYarn is already installed.\e[0m"
    fi
else
    echo -e "\e[33mInstalling Yarn...\e[0m"
    if ! run_with_sudo npm install -g yarn; then
        echo -e "\e[31mFailed to install Yarn.\e[0m"
        exit 1
    fi
fi

# Check and install PM2
if ! command -v pm2 &> /dev/null; then
    echo -e "\e[33mInstalling PM2...\e[0m"
    if ! yarn global add pm2; then
        echo -e "\e[31mFailed to install PM2.\e[0m"
        exit 1
    fi
else
    echo -e "\e[32mPM2 is already installed.\e[0m"
fi

# Clone the repository
echo -e "\e[33mCloning Levanter repository...\e[0m"
if ! git clone https://github.com/lyfe00011/levanter.git "$BOT_NAME"; then
    echo -e "\e[31mFailed to clone repository.\e[0m"
    exit 1
fi
cd "$BOT_NAME"

# Install dependencies
echo -e "\e[33mInstalling dependencies with Yarn...\e[0m"
if ! yarn install --network-concurrency 3; then
    echo -e "\e[31mFailed to install dependencies.\e[0m"
    exit 1
fi

# Create config.env file
echo -e "\e[33mCreating config.env file...\e[0m"
cat > config.env <<EOL
PREFIX=.
STICKER_PACKNAME=LyFE
ALWAYS_ONLINE=false
RMBG_KEY=null
LANGUAGE=en
WARN_LIMIT=3
FORCE_LOGOUT=false
BRAINSHOP=159501,6pq8dPiYt7PdqHz3
MAX_UPLOAD=60
REJECT_CALL=false
SUDO=989876543210
TZ=Asia/Kolkata
VPS=true
AUTO_STATUS_VIEW=true
SEND_READ=true
AJOIN=true
EOL

echo "NAME=$BOT_NAME" >> config.env

if [ -n "$SESSION_ID" ]; then
    echo "SESSION_ID=$SESSION_ID" >> config.env
fi

# Start the bot
echo -e "\e[33mStarting the bot...\e[0m"
if ! pm2 start index.js --name "$BOT_NAME" --attach; then
    echo -e "\e[31mFailed to start the bot.\e[0m"
    exit 1
fi
