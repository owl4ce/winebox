#!/usr/bin/env bash

# Run MikroTik Winbox over WINE
# Author: owl4ce

# Colored output
RED='\033[1;31m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'

chkwinbox="$(ls ~/.winebox/ | grep "winbox")"
chkarch="$(lscpu | grep "Architecture" | awk -F' ' '{print $2}')"
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

# Setup
cp -r ./.winebox/ ~/
clear

# Detecting OS architecture
if [[ $chkarch = *"x86_64"* ]]; then

    echo -e -n "${CYAN}Detected OS architecture... "
    echo -e "${GREEN}64-bit"
    
    if [[ $chkwinbox != *"winbox64.exe"* ]]; then
        echo -e "${CYAN}Downloading Winbox..."
        echo -e "\033[0m"
        wget --progress=bar:force https://mt.lv/winbox64 -O ~/.winebox/winbox64.exe 2>&1 | progressfilt
    else
        echo -e -n "\033[0m"
        while true; do
        echo -n "Winbox already exists. "
        read -p "Do you wish to reinstall/upgrade Winbox? (y/n) " yn
            case $yn in
                [Yy]* ) clear
                        echo -e "${CYAN}Upgrading Winbox..."
                        echo -e "\033[0m"
                        wget --progress=bar:force https://mt.lv/winbox64 -O ~/.winebox/winbox64.exe 2>&1 | progressfilt;
                        break;;
                [Nn]* ) exit;;
                * ) echo -e "${RED}Please answer yes or no."
                    echo -e -n "\033[0m";;
            esac
        done
    fi
    
    echo -n -e "${CYAN}Creating desktop shortcut (Winebox)... "
    
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
    
    echo -e -n "${CYAN}Detected OS architecture... "
    echo -e "${GREEN}32-bit"
    
    if [[ $chkwinbox != *"winbox.exe"* ]]; then
        echo -e "${CYAN}Downloading Winbox..."
        echo -e "\033[0m"
        wget --progress=bar:force https://mt.lv/winbox -O ~/.winebox/winbox.exe 2>&1 | progressfilt
    else
        echo -e -n "\033[0m"
        while true; do
        echo -n "Winbox already exists. "
        read -p "Do you wish to reinstall/upgrade Winbox? (y/n) " yn
            case $yn in
                [Yy]* ) clear
                        echo -e "${CYAN}Upgrading Winbox..."
                        echo -e "\033[0m"
                        wget --progress=bar:force https://mt.lv/winbox -O ~/.winebox/winbox.exe 2>&1 | progressfilt;
                        break;;
                [Nn]* ) exit;;
                * ) echo -e "${RED}Please answer yes or no."
                    echo -e -n "\033[0m";;
            esac
        done
    fi
    
    echo -n -e "${CYAN}Creating desktop shortcut (Winebox)... "
    
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
