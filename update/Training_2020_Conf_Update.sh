#!/bin/bash

######################################################
##      SERMA SAFETY AND SECURITY
##      Author : MDM
##      Version : 1.3.4
##      Date : 28/08/2020
##
##      Objective : Update configuration and exercices
##       To use do :
##        sh -c "$(curl -fsSL https://raw.githubusercontent.com/serma-safety-security/Training_Ressources/master/update/Training_2020_Conf_Update.sh)"
##
######################################################

# Reset
NC='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

read -r -d '' ASCII_ART_TITLE  <<"EOF"
*    ____
     |___ \
  ___  __) |_ __ _ __ ___   __ _
 / __||__ <| '__| '_ ` _ \ / _` |
 \__ \___) | |  | | | | | | (_| |
 |___/____/|_|  |_| |_| |_|\__,_|        _       _
  / ____|           / _| |  | |         | |     | |
 | |     ___  _ __ | |_| |  | |_ __   __| | __ _| |_ ___
 | |    / _ \| '_ \|  _| |  | | '_ \ / _` |/ _` | __/ _ \
 | |___| (_) | | | | | | |__| | |_) | (_| | (_| | ||  __/
  \_____\___/|_| |_|_|  \____/| .__/ \__,_|\__,_|\__\___|
                              | |
                              |_|

EOF
printf "${Yellow}$ASCII_ART_TITLE${NC}\n"

# Start Script
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Start Script${NC}\n"
printf "${Green}Begin update & upgrade${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y upgrade

# Software installation
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Software installation${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo apt-get -y install audacity wxhexeditor
sudo apt -y install openvpn bridge-utils

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Deleting obsolete files and folders${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
cd "$HOME"
sudo rm -r ~/Downloads/qemu
rm -r "$HOME"/Desktop/exercice/2_sdr/*

cd "$HOME"/Desktop/exercice/1_bof/
rm payload.pl README.md,stack5.c 
cd "$HOME"

# Exercice update
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Exercice Updates${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
cd "$HOME"
git clone https://github.com/serma-safety-security/Training_Ressources.git
mv "$HOME"/Training_Ressources/ "$HOME"/Downloads/
rsync -a "$HOME"/Downloads/Training_Ressources/exercices/* "$HOME"/Desktop/exercice/
chmod +x "$HOME"/Desktop/exercice/1_bof/payload.pl
chmod +x "$HOME"/Desktop/exercice/2_sdr/receive_data
chmod +x "$HOME"/Desktop/exercice/2_sdr/send_data
chmod +x "$HOME"/Desktop/exercice/3_ctf/refinium

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Spring Cleaning${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo apt -y autoremove
sudo rm -rf "$HOME"/Downloads/Training_Ressources
sudo rm -rf "$HOME"/Downloads/WiringPi

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Change SSH welcome screen${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
cat /etc/ssh/sshd_config | sed -e "s/#Banner none/Banner \/etc\/banner/" | sudo tee /etc/ssh/sshd_config
read -r -d '' CompanyName<< EOM
╔══════════════════════════════════════════╗
║ ______         ___ _       _             ║
║(_____ \       / __|_)     (_)            ║
║ _____) ) ____| |__ _ ____  _ _   _ ____  ║
║(_____ ( / _  )  __) |  _ \| | | | |    \ ║
║      | ( (/ /| |  | | | | | | |_| | | | |║
║      |_|\____)_|  |_|_| |_|_|\____|_|_|_|║
╚══════════════════════════════════════════╝
EOM

read -r -d '' RadioactiveHazard << EOM
*                xxxxxxx
            x xxxxxxxxxxxxx x
         x     xxxxxxxxxxx     x
                xxxxxxxxx
      x          xxxxxxx          x
                  xxxxx
     x             xxx             x
                    x
    xxxxxxxxxxxxxxx   xxxxxxxxxxxxxxx
     xxxxxxxxxxxxx     xxxxxxxxxxxxx
      xxxxxxxxxxx       xxxxxxxxxxx
       xxxxxxxxx         xxxxxxxxx
         xxxxxx           xxxxxx
           xxx             xxx
               x         x
                    x
═══DANGER YOU ARE IN A RADIOACTIVE ZONE!!!════
EOM

SSH_Banner="$CompanyName$\n$RadioactiveHazard\n"
printf "$SSH_Banner" | sudo tee /etc/banner


# Reboot
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Reboot${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
echo "About to execute reboot command"
echo -n "Would you like to proceed y/n? "
read reply
if [ "$reply" = y -o "$reply" = Y ]
then
   sudo reboot now
else
   echo "Reboot cancelled"
fi
