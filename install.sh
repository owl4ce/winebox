#!/usr/bin/env bash

# Bash script to install winbox on Linux (WINE)
# Author: owl4ce
# License: GPL-3.0
# ---------------------------------------------
# https://github.com/owl4ce/winebox

RED='\033[1;31m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
NC='\033[0m'

chk_wine="$(wine --version)"
chk_arch="$(lscpu | grep "Architecture" | awk -F'_' '{print $2}')"

function progressfilt {
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%s' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}

function mkds {
    [[ ! -e $HOME/.local/share/applications ]] && mkdir -p $HOME/.local/share/applications
    touch $HOME/.local/share/applications/winebox.desktop
    chmod +x $HOME/.local/share/applications/winebox.desktop
}

function dtwine {
    if [[ $chk_wine = *"wine"* ]]; then
        echo -e -n "${CYAN}Detected Wine version: "
        echo -e "${NC}$chk_wine"
    else
        echo -e -n "${RED}Wine is not installed. "
        echo -e "${NC}Please install the wine first!"
        exit 1
    fi
}

case $1 in
    --uninstall)
        if [[ -e $HOME/.winebox ]]; then
            rm -rv $HOME/.{winebox,local/share/applications/winebox.desktop} && echo -e "${GREEN}Winebox successfuly uninstalled."
        fi
    ;;
    *)  clear
        if [[ $EUID -ne 0 ]]; then    
            dtwine
            echo -n -e "${CYAN}Detected OS architecture: "
            echo -e "${NC}$chk_arch-bit"
            echo -e "\033[0m"
            cp -r ./.winebox $HOME/
            if [[ $chk_arch = *"64"* ]]; then
                if [[ ! -f $HOME/.winebox/winbox64.exe ]]; then
                    echo -e "${CYAN}Downloading Winbox ${MAGENTA}(64-bit)${CYAN}..."
                    echo -e "\033[0m"
                    wget --progress=bar:force https://mt.lv/winbox64 -O $HOME/.winebox/winbox64.exe 2>&1 | progressfilt
                else
                    while true; do
                    echo -n -e "${GREEN}Winbox already exists. "
                    echo -n -e "\033[0m"
                    read -p $'Do you wish to reinstall/upgrade Winbox? \e[1;35m(y/n)\e[0m ' yn
                        case $yn in
                            [Yy]* ) clear
                                    echo -e "${CYAN}Upgrading Winbox ${MAGENTA}(64-bit)${CYAN}..."
                                    echo -e "\033[0m"
                                    wget --progress=bar:force https://mt.lv/winbox64 -O $HOME/.winebox/winbox64.exe 2>&1 | progressfilt;
                                    break;;
                            [Nn]* ) exit;;
                            * ) echo -e "${RED}Please answer yes or no."
                                echo -n -e "\033[0m";;
                        esac
                    done
                fi
                echo -n -e "${CYAN}Creating desktop shortcut... "
                mkds
                echo "[Desktop Entry]
Comment=Run MikroTik Winbox over Wine (64-bit)
Terminal=false
Name=Winebox
Categories=Network;
Exec=bash -c 'wine64 $HOME/.winebox/winbox64.exe'
Type=Application
Icon=$(echo $HOME)/.winebox/winebox.png" > $HOME/.local/share/applications/winebox.desktop
                sleep 1s
                echo -e "${GREEN}Winebox successfully installed!"
            else
                if [[ ! -f $HOME/.winebox/winbox.exe ]]; then
                    echo -e "${CYAN}Downloading Winbox ${MAGENTA}(32-bit)${CYAN}..."
                    echo -e "\033[0m"
                    wget --progress=bar:force https://mt.lv/winbox -O $HOME/.winebox/winbox.exe 2>&1 | progressfilt
                else
                    while true; do
                    echo -n -e "${GREEN}Winbox already exists. "
                    echo -n -e "\033[0m"
                    read -p $'Do you wish to reinstall/upgrade Winbox? \e[1;35m(y/n)\e[0m ' yn
                        case $yn in
                            [Yy]* ) clear
                                    echo -e "${CYAN}Upgrading Winbox ${MAGENTA}(32-bit)${CYAN}..."
                                    echo -e "\033[0m"
                                    wget --progress=bar:force https://mt.lv/winbox -O $HOME/.winebox/winbox.exe 2>&1 | progressfilt;
                                    break;;
                            [Nn]* ) exit;;
                            * ) echo -e "${RED}Please answer yes or no."
                                echo -n -e "\033[0m";;
                        esac
                    done
                fi
                echo -n -e "${CYAN}Creating desktop shortcut... "
                mkds
                echo "[Desktop Entry]
Comment=Run MikroTik Winbox over Wine (32-bit)
Terminal=false
Name=Winebox
Categories=Network;
Exec=bash -c 'wine $HOME/.winebox/winbox.exe'
Type=Application
Icon=$(echo $HOME)/.winebox/winebox.png" > $HOME/.local/share/applications/winebox.desktop
                sleep 1s
                echo -e "${GREEN}Winebox successfully installed!"
            fi
        else
            echo -e "${RED}Running as root is detected! Please run as regular user."
            exit 1
        fi
    ;;
esac
