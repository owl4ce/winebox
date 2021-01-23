#!/usr/bin/env bash

# Bash script to install winbox on Linux (wine)
# Author: owl4ce
# License: GPL-3.0
# ---------------------------------------------
# https://github.com/owl4ce/winebox

RED='\033[1;31m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
NC='\033[0m'

CHK_ARCH="$(lscpu | grep "Architecture" | awk -F'_' '{print $2}')"
winbox() { curl -L "https://mt.lv/winbox" -o $HOME/.winebox/winbox.exe; }
winbox64() { curl -L "https://mt.lv/winbox64" -o $HOME/.winebox/winbox64.exe; }

mkds() {
    [[ ! -e $HOME/.local/share/applications ]] && mkdir -p $HOME/.local/share/applications
    touch $HOME/.local/share/applications/winebox.desktop && chmod +x $HOME/.local/share/applications/winebox.desktop
}

dtwine() {
    if [[ -x "$(which "wine" 2> /dev/null)" ]]; then
        echo -e -n "${CYAN}Detected Wine version: "
        echo -e "${NC}$(wine --version)"
    else
        echo -e -n "${RED}Wine is not installed. "
        echo -e "${NC}Please install the wine first!"
        exit 1
    fi
}

case $1 in
    -u) if [[ -e $HOME/.winebox ]]; then
            rm -rv $HOME/.{winebox,local/share/applications/winebox.desktop}
            echo -e "${GREEN}Winebox successfuly uninstalled."
        fi
    ;;
    *)  clear
        if [[ $EUID -ne 0 ]]; then    
            dtwine
            echo -n -e "${CYAN}Detected OS architecture: "
            echo -e "${NC}$CHK_ARCH-bit" && echo -e "${NC}"
            [[ ! -e $HOME/.winebox ]] && \
            mkdir -p $HOME/.winebox && \
            curl -sL "https://raw.githubusercontent.com/owl4ce/winebox/main/.winebox/winebox.png" -o $HOME/.winebox/winebox.png
            if [[ $CHK_ARCH = *"64"* ]]; then
                if [[ ! -f $HOME/.winebox/winbox64.exe ]]; then
                    echo -e "${CYAN}Downloading Winbox ${MAGENTA}(64-bit)${CYAN}..." && echo -e "${NC}"
                    winbox64
                else
                    echo -n -e "${GREEN}Winbox already exists. ${RED}Exiting.." && exit 1
                fi
                echo -n -e "${CYAN}Creating desktop shortcut... "
                mkds
                echo "[Desktop Entry]
Comment=Run MikroTik Winbox over Wine (64-bit)
Terminal=false
Name=Winebox
Categories=Network;
Exec=bash -c \"wine64 $HOME/.winebox/winbox64.exe\"
Type=Application
Icon=$(echo $HOME)/.winebox/winebox.png" > $HOME/.local/share/applications/winebox.desktop
                sleep 1s && echo -e "${GREEN}Winebox successfully installed!"
            else
                if [[ ! -f $HOME/.winebox/winbox.exe ]]; then
                    echo -e "${CYAN}Downloading Winbox ${MAGENTA}(32-bit)${CYAN}..." && echo -e "${NC}"
                    winbox
                else
                    echo -n -e "${GREEN}Winbox already exists. ${RED}Exiting.." && exit 1
                fi
                echo -n -e "${CYAN}Creating desktop shortcut... "
                mkds
                echo "[Desktop Entry]
Comment=Run MikroTik Winbox over Wine (32-bit)
Terminal=false
Name=Winebox
Categories=Network;
Exec=bash -c \"wine $HOME/.winebox/winbox.exe\"
Type=Application
Icon=$(echo $HOME)/.winebox/winebox.png" > $HOME/.local/share/applications/winebox.desktop
                sleep 1s && echo -e "${GREEN}Winebox successfully installed!"
            fi
        else
            echo -e "${RED}Running as root is detected! Please run as regular user."
            exit 1
        fi
    ;;
esac
