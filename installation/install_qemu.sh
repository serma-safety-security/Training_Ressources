#!/bin/bash

######################################################
##      SERMA SAFETY AND SECURITY
##      Author : MDM
##      Version : 1.0.0
##      Date : 29/07/2020
##  
##      Objective : Compile and install QEMU
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
*     ____                                               
     |___ \                                              
  ___  __) |_ __ _ __ ___   __ _                         
 / __||__ <| '__| '_ ` _ \ / _` |                        
 \__ \___) | |  | | | | | | (_| |                        
 |___/____/|_|  |_| |_| |_|\__,_|                        
  / __ \                     |_   _|         | |      | |
 | |  | | ___ _ __ ___  _   _  | |  _ __  ___| |_ __ _| |
 | |  | |/ _ \ '_ ` _ \| | | | | | | '_ \/ __| __/ _` | |
 | |__| |  __/ | | | | | |_| |_| |_| | | \__ \ || (_| | |
  \___\_\\___|_| |_| |_|\__,_|_____|_| |_|___/\__\__,_|_|

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


# Installing dependancies  
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Intsalling depandancies${NC}\n"
printf "${Green}libglib2.0-dev and libpixman-1-dev ${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"

sudo apt-get -y install libglib2.0-dev libpixman-1-dev

# Downloading qemu source code 
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Downloading QEMU source code${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
cd ~/Downloads
git clone https://github.com/qemu/qemu.git
cd qemu 

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Building${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
mkdir build
cd build

# Configuring
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Configuring${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
../configure

# Compiling
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Compiling${NC}\n"
printf "${Green}  This should take maximum 3 Hours${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
make -j 5  

# Installing
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Installing${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo make install


printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Spring cleaning${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo apt autoremove
sudo rm -r ~/Downloads/qemu