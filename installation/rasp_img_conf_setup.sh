#!/bin/bash

######################################################
##      SERMA SAFETY AND SECURITY
##      Author : MDM
##      Version : 1.0.0
##      Date : 29/07/2020
##  
##      Objective : Create QEMU environement and scripts
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
 |___/____/|_|  |_| |_| |_|\__,_|      ______                   
 |  __ \|  __ (_)_   _|               |  ____|           
 | |__) | |__) |  | |  _ __ ___   __ _| |__   _ ____   __
 |  _  /|  ___/ | | | | '_ ` _ \ / _` |  __| | '_ \ \ / /
 | | \ \| |   | |_| |_| | | | | | (_| | |____| | | \ V / 
 |_|  \_\_|   |_|_____|_| |_| |_|\__, |______|_| |_|\_/  
    _____            __ _        __/ |                  
  / ____|           / _(_)       |___/                   
 | |     ___  _ __ | |_ _  __ _                          
 | |    / _ \| '_ \|  _| |/ _` |                         
 | |___| (_) | | | | | | | (_| |                         
  \_____\___/|_| |_|_| |_|\__, |                         
                           __/ |                         
                          |___/                          

EOF

printf "${Yellow}$ASCII_ART_TITLE${NC}\n"


# Variable definitions
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Variable definitions${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
PATH_QEMU_RPI_IMG="$HOME/Desktop/exercice/1_bof/RpiImage/"
echo PATH_QEMU_RPI_IMG="$PATH_QEMU_RPI_IMG"

PATH_QEMU_RPI_KERNEL="$PATH_QEMU_RPI_IMG/Kernel/"
echo PATH_QEMU_RPI_KERNEL="$PATH_QEMU_RPI_KERNEL"

URL_RASPBIAN_IMG="https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2020-02-14/"
echo URL_RASPBIAN_IMG="$URL_RASPBIAN_IMG"

RPI_IMG_ZIP_SHA1="2020-02-13-raspbian-buster-lite.zip.sha1"
echo RPI_IMG_ZIP_SHA1="$RPI_IMG_ZIP_SHA1"

RPI_IMG_ZIP="2020-02-13-raspbian-buster-lite.zip"
echo RPI_IMG_ZIP="$RPI_IMG_ZIP"

RPI_IMG="2020-02-13-raspbian-buster-lite.img"
echo RPI_IMG="$RPI_IMG"

URL_QEMU_RESSOURCES="https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/"
echo URL_QEMU_RESSOURCES="$URL_QEMU_RESSOURCES"

QEMU_RPI_KERNEL="kernel-qemu-4.19.50-buster"
echo QEMU_RPI_KERNEL="$QEMU_RPI_KERNEL"

QEMU_RPI_DTB="versatile-pb-buster.dtb"
echo QEMU_RPI_DTB="$QEMU_RPI_DTB"

START_QEMU_SCRIPT_NAME="start_qemu.sh"
echo START_QEMU_SCRIPT_NAME="$START_QEMU_SCRIPT_NAME"

MNT_BRIDGE_SCRIPT_NAME="make_bridge.sh"
echo MNT_BRIDGE_SCRIPT_NAME="$MNT_BRIDGE_SCRIPT_NAME"

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
sudo apt -y install openvpn bridge-utils

#Creation of folders
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Creation of folders${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
mkdir -p $PATH_QEMU_RPI_IMG
mkdir -p $PATH_QEMU_RPI_KERNEL

#Download to folders
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Download to folders${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
axel --num-connections=10 -a "$URL_RASPBIAN_IMG$RPI_IMG_ZIP_SHA1" -o "$PATH_QEMU_RPI_IMG/$RPI_IMG_ZIP_SHA1"
axel --num-connections=10 -a "$URL_RASPBIAN_IMG$RPI_IMG_ZIP" -o "$PATH_QEMU_RPI_IMG/$RPI_IMG_ZIP"
axel --num-connections=10 -a "$URL_QEMU_RESSOURCES$QEMU_RPI_KERNEL" -o "$PATH_QEMU_RPI_KERNEL/$QEMU_RPI_KERNEL"
axel --num-connections=10 -a "$URL_QEMU_RESSOURCES$QEMU_RPI_DTB" -o "$PATH_QEMU_RPI_KERNEL/$QEMU_RPI_DTB"

sha1sum -c *.sha1

# Unzipping image
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green} Unzipping raspberry Pi zip{NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
unzip $PATH_QEMU_RPI_IMG/$RPI_IMG_ZIP -d $PATH_QEMU_RPI_IMG
#qemu-img resize $PATH_QEMU_RPI_IMG$RPI_IMG +2G #Maybe not necessary because only gef to be installed on Machine

#Create start_qemu.sh script
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Create start_qemu.sh script${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
cat <<EOF  > $PATH_QEMU_RPI_IMG/../$START_QEMU_SCRIPT_NAME
#!/bin/bash
qemu-system-arm \\
-M versatilepb \\
-cpu arm1176 \\
-m 256 \\
-netdev bridge,id=hn0 \\
-device virtio-net-pci,netdev=hn0,id=nic1 \\
-kernel $PATH_QEMU_RPI_KERNEL/$QEMU_RPI_KERNEL \\
-dtb $PATH_QEMU_RPI_KERNEL/$QEMU_RPI_DTB \\
-no-reboot \\
-serial stdio \\
-append "root=/dev/sda2 panic=1 rootfstype=ext4 rw console=ttyAMA0" \\
-drive file=$PATH_QEMU_RPI_IMG$RPI_IMG,format=raw,index=0,media=disk
EOF

chmod +x $PATH_QEMU_RPI_IMG/../$START_QEMU_SCRIPT_NAME

#Configure acl for bridge helper of qemu
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Create ACL for bridge helper${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
# In case of manually compiled qemu, create first the /etc/qemu folder:
sudo mkdir /etc/qemu
sudo mkdir -p /usr/local/etc/qemu/
# Allow users to use br0:
echo "allow br0" | sudo tee -a /etc/qemu/bridge.conf
echo "allow br0" | sudo tee -a /usr/local/etc/qemu/bridge.conf


#Mount a bridge between internet connexion interface and a tun/tap fake device
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Bridge Internet and tun/tap fake device${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
SCRIPT_NAME=make_bridge.sh
cat <<EOF > $PATH_QEMU_RPI_IMG/$MNT_BRIDGE_SCRIPT_NAME
#!/usr/bin/env bash

# Use by typing ./make_bridge.sh eth0 tap0

if [ "\$#" -ne 2 ]
then
echo "ERROR: Wrong arguments count"
echo "USAGE: $0 host_internet_device tap_device_to_create"
echo "Example: $0 enp0s36 tap0"
exit
fi

NETDEVICE=\$1
TAPDEVICE=\$2

if [ \$(which brctl 2>/dev/null ) ]
then
if [ \$(which openvpn 2>/dev/null ) ]
then
echo "Creating tun/tap device \$TAPDEVICE"
sudo /usr/sbin/openvpn --mktun --dev \$TAPDEVICE --user `id -un`
echo "Turning down \$NETDEVICE"
sudo ip link set down \$NETDEVICE
echo "Creating br0 empty bridge"
sudo brctl addbr br0
echo "adding internet host device to bridge"
sudo brctl addif br0 \$NETDEVICE
echo "adding tun/tap host device to bridge"
sudo brctl addif br0 \$TAPDEVICE
echo "Turning up bridge"
sudo ip link set up br0
echo "Turning up tap"
sudo ip link set up \$TAPDEVICE
echo "Turning up \$NETDEVICE"
sudo ip link set up \$NETDEVICE
echo "Running dhcp client on bridge"
sudo dhclient br0
else
echo "openvpn command not found"
fi
else
echo "brctl command not found"
fi
EOF

chmod +x $PATH_QEMU_RPI_IMG/$MNT_BRIDGE_SCRIPT_NAME