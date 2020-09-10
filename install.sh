#!/usr/bin/env bash

# Winbox installer for linux run over wine
# Author: owl4ce
# License: GPL-3.0
# ---------------------------------
# https://github.com/owl4ce/winebox

# Colored output
RED='\033[1;31m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
NC='\033[0m'

chkwine="$(wine --version)"
chkwinbox="$(ls ~/.winebox/ | grep "winbox")"
chkarch="$(lscpu | grep "Architecture" | awk -F'_' '{print $2}')"
progressfilt ()
{
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

mkds ()
{
    touch ~/.local/share/applications/winebox.desktop
    chmod +x ~/.local/share/applications/winebox.desktop
}

dtwine ()
{
    if [[ $chkwine = *"wine"* ]]; then
        echo -e -n "${CYAN}Detected Wine version: "
        echo -e "${NC}$chkwine"
    else
        echo -e -n "${RED}Wine is not installed. "
        echo -e "${NC}Please install the wine first!"
        exit 1
    fi
}

clear

# ROOT DETECTION
if [[ $(whoami) != *"root"* ]]; then
    
    # REGULAR USER INSTALLATION
    dtwine
    echo -n -e "${CYAN}Detected OS architecture: "
    echo -e "${NC}$chkarch-bit"
    echo -e "\033[0m"
    cp -r ./.winebox/ ~/
    
    if [[ $chkarch = *"64"* ]]; then
        
        if [[ $chkwinbox != *"winbox64.exe"* ]]; then
            echo -e "${CYAN}Downloading Winbox ${MAGENTA}(64-bit)${CYAN}..."
            echo -e "\033[0m"
            wget --progress=bar:force https://mt.lv/winbox64 -O ~/.winebox/winbox64.exe 2>&1 | progressfilt
        else
            while true; do
            echo -n -e "${GREEN}Winbox already exists. "
            echo -n -e "\033[0m"
            read -p $'Do you wish to reinstall/upgrade Winbox? \e[1;35m(y/n)\e[0m ' yn
                case $yn in
                    [Yy]* ) clear
                            echo -e "${CYAN}Upgrading Winbox ${MAGENTA}(64-bit)${CYAN}..."
                            echo -e "\033[0m"
                            wget --progress=bar:force https://mt.lv/winbox64 -O ~/.winebox/winbox64.exe 2>&1 | progressfilt;
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
Comment=Run MikroTik Winbox over WINE (64-bit)
Terminal=false
Name=Winebox
Categories=Network;
Exec=bash -c 'wine64 ~/.winebox/winbox64.exe'
Type=Application
Icon=/home/$(whoami)/.winebox/winebox.png" > ~/.local/share/applications/winebox.desktop
        sleep 2s
        echo -e "${GREEN}Winebox successfully installed!"
        
    else
        
        if [[ $chkwinbox != *"winbox.exe"* ]]; then
            echo -e "${CYAN}Downloading Winbox ${MAGENTA}(32-bit)${CYAN}..."
            echo -e "\033[0m"
            wget --progress=bar:force https://mt.lv/winbox -O ~/.winebox/winbox.exe 2>&1 | progressfilt
        else
            while true; do
            echo -n -e "${GREEN}Winbox already exists. "
            echo -n -e "\033[0m"
            read -p $'Do you wish to reinstall/upgrade Winbox? \e[1;35m(y/n)\e[0m ' yn
                case $yn in
                    [Yy]* ) clear
                            echo -e "${CYAN}Upgrading Winbox ${MAGENTA}(32-bit)${CYAN}..."
                            echo -e "\033[0m"
                            wget --progress=bar:force https://mt.lv/winbox -O ~/.winebox/winbox.exe 2>&1 | progressfilt;
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
Comment=Run MikroTik Winbox over WINE (32-bit)
Terminal=false
Name=Winebox
Categories=Network;
Exec=bash -c 'wine ~/.winebox/winbox.exe'
Type=Application
Icon=/home/$(whoami)/.winebox/winebox.png" > ~/.local/share/applications/winebox.desktop
        sleep 2s
        echo -e "${GREEN}Winebox successfully installed!"
        
    fi
    
else
    
    # ROOT INSTALLATION
    echo -e "${RED}Running as root is detected!"
    echo -e "\033[0m"
    dtwine
    echo -n -e "${CYAN}Detected OS architecture: "
    echo -e "${NC}$chkarch-bit"
    echo -e "\033[0m"
    
    while true; do
    read -p $'Do you wish to install Winbox as \e[1;31mroot\e[0m? \e[1;35m(y/n)\e[0m ' yn
        case $yn in
            [Yy]* ) cp -r ./.winebox/ ~/
                    clear
                    
                    if [[ $chkarch = *"64"* ]]; then
                        
                        if [[ $chkwinbox != *"winbox64.exe"* ]]; then
                            echo -e "${CYAN}Downloading Winbox ${MAGENTA}(64-bit)${CYAN}..."
                            echo -e "\033[0m"
                            wget --progress=bar:force https://mt.lv/winbox64 -O ~/.winebox/winbox64.exe 2>&1 | progressfilt
                        else
                            while true; do
                            echo -n -e "${GREEN}Winbox already exists. "
                            echo -n -e "\033[0m"
                            read -p $'Do you wish to reinstall/upgrade Winbox? \e[1;35m(y/n)\e[0m ' yn
                                case $yn in
                                    [Yy]* ) clear
                                            echo -e "${CYAN}Upgrading Winbox ${MAGENTA}(64-bit)${CYAN}..."
                                            echo -e "\033[0m"
                                            wget --progress=bar:force https://mt.lv/winbox64 -O ~/.winebox/winbox64.exe 2>&1 | progressfilt;
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
Comment=Run MikroTik Winbox over WINE (64-bit)
Terminal=false
Name=Winebox
Categories=Network;
Exec=bash -c 'wine64 ~/.winebox/winbox64.exe'
Type=Application
Icon=/root/.winebox/winebox.png" > ~/.local/share/applications/winebox.desktop
                        sleep 2s
                        echo -e "${GREEN}Winebox successfully installed as ${RED}root${GREEN}!"
                        
                    else
                        
                        if [[ $chkwinbox != *"winbox.exe"* ]]; then
                            echo -e "${CYAN}Downloading Winbox ${MAGENTA}(32-bit)${CYAN}..."
                            echo -e "\033[0m"
                            wget --progress=bar:force https://mt.lv/winbox -O ~/.winebox/winbox.exe 2>&1 | progressfilt
                        else
                            while true; do
                            echo -n -e "${GREEN}Winbox already exists. "
                            echo -n -e "\033[0m"
                            read -p $'Do you wish to reinstall/upgrade Winbox? \e[1;35m(y/n)\e[0m ' yn
                                case $yn in
                                    [Yy]* ) clear
                                            echo -e "${CYAN}Upgrading Winbox ${MAGENTA}(32-bit)${CYAN}..."
                                            echo -e "\033[0m"
                                            wget --progress=bar:force https://mt.lv/winbox -O ~/.winebox/winbox.exe 2>&1 | progressfilt;
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
Comment=Run MikroTik Winbox over WINE (32-bit)
Terminal=false
Name=Winebox
Categories=Network;
Exec=bash -c 'wine ~/.winebox/winbox.exe'
Type=Application
Icon=/root/.winebox/winebox.png" > ~/.local/share/applications/winebox.desktop
                        sleep 2s
                        echo -e "${GREEN}Winebox successfully installed as ${RED}root${GREEN}!"
                        
                    fi;
                    break;;
            [Nn]* ) exit;;
            * ) echo -e "${RED}Please answer yes or no."
                echo -n -e "\033[0m";;
        esac
    done
    
fi
