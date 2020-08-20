#!/bin/bash

######################################################
##      SERMA SAFETY AND SECURITY
##      Author : MDM
##      Version : 1.3.2
##      Date : 20/08/2020
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
sudo apt-get -y install wireshark nmap zenmap
sudo apt install -y python3-pyqt5
sudo apt-get install i2c-tools

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Deleting obsolete files and folders${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
cd "$HOME"
sudo rm -r ~/Downloads/qemu
rm -r "$HOME"/Desktop/exercice/2_sdr/*

cd "$HOME"/Desktop/exercice/1_bof/
rm payload.pl README.md,stack5.c 
cd "$HOME"

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Change payload file in QEMU Image${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
cd "$HOME"/Desktop/exercice/1_bof/RpiImage
OFFSET_BEGIN=$(fdisk -l 2020-02-13-raspbian-buster-lite.img | grep ".img2" | awk '{ print $2 }')
OFFSET_SIZE=$((512 * $OFFSET_BEGIN))
echo OFFSET_SIZE="$OFFSET_SIZE"
sudo mkdir /mnt/raspbian
#sudo mount -v -o offset=272629760 -t ext4 2020-02-13-raspbian-buster-lite.img /mnt/raspbian
sudo mount -v -o offset="$OFFSET_SIZE" -t ext4 2020-02-13-raspbian-buster-lite.img /mnt/raspbian
cp "$HOME"/Desktop/exercice/1_bof/payload.pl /mnt/raspbian/home/pi/payload.pl
cd ~
sudo umount /mnt/raspbian
sudo rm -r /mnt/raspbian

# Exercice update
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Exerice Updates${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
cd "$HOME"
git clone https://github.com/serma-safety-security/Training_Ressources.git
mv "$HOME"/Training_Ressources/ "$HOME"/Downloads/
rsync -a "$HOME"/Downloads/Training_Ressources/exercices/* "$HOME"/Desktop/exercice/
chmod +x "$HOME"/Desktop/exercice/1_bof/payload.pl
chmod +x "$HOME"/Desktop/exercice/2_sdr/receive_data
chmod +x "$HOME"/Desktop/exercice/2_sdr/send_data

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Spring Cleaning${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo apt -y autoremove
sudo rm -rf "$HOME"/Downloads/Training_Ressources
sudo rm -rf "$HOME"/Downloads/WiringPi

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