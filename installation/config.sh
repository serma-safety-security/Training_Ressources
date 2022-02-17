#!/bin/bash

######################################################
##      SERMA SAFETY AND SECURITY
##      Author : MDM
##      Version : 1.0.2
##      Date : 19/03/2021
##  
##      Objective : Configure Raspberry Pi
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
 |___/____/|_|  |_| |_| |_|\__,_|    __
  / ____|           / _(_)          /_ |
 | |     ___  _ __ | |_ _  __ ___   _| |
 | |    / _ \| '_ \|  _| |/ _` \ \ / / |
 | |___| (_) | | | | | | | (_| |\ V /| |
  \_____\___/|_| |_|_| |_|\__, | \_/ |_|
                           __/ |
                          |___/

EOF
printf "${Yellow}$ASCII_ART_TITLE${NC}\n"

# Variable definitions
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Variable definitions${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"

# Start Script
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Start Script${NC}\n"
printf "${Green}Begin update & upgrade${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y upgrade

# Start Script
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Software installation${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo apt -y install gqrx-sdr openocd hexedit
#Silent install of wireshark and auto accept wireshark run as root
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install wireshark
sudo apt install gdb-multiarch telnet
sudo apt-get install -y axel wireshark nmap zenmap
sudo apt-get -y install audacity wxhexeditor
sudo apt -y install openvpn bridge-utils
sudo apt-get install i2c-tools
echo "dtparam=i2c_arm=on" | sudo tee -a /boot/config.txt

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Install Hardsploit${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
## The strict minimum dependancies should eventualy be installed so tests are necessary
sudo apt-get install ruby ruby-dev cmake build-essential dfu-util libqt4-dev libusb-1.0-0 \
bison openssl libreadline5 libreadline-dev git-core zlib1g zlib1g-dev libssl-dev \
libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev subversion autoconf xorg-dev \
libgl1-mesa-dev libglu1-mesa-dev

sudo gem install qtbindings activerecord libusb sqlite3
gem install sqlite3 -v 1.3.9

sudo gem install hardsploit_gui

## QT_X11_NO_MITSHM=1

# URH
printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Install URH${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
# Install RTL-SDR support for URH
sudo apt install librtlsdr-dev
# Now install URH
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install cython
sudo apt -y install python3-pyqt5
cd /home/pi
git clone https://github.com/jopohl/urh.git
cd urh
sudo python3 setup.py install

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Disable Kernel Security${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo bash -c "echo 'kernel.randomize_va_space = 0' > /etc/sysctl.d/1-aslr.conf"

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Install gef extension for GDB${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
cd /home/pi
sudo curl -s -L https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Enable VNC${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo ln -s /usr/lib/systemd/system/vncserver-x11-serviced.service /etc/systemd/system/multi-user.target.wants/vncserver-x11-serviced.service
sudo systemctl start vncserver-x11-serviced

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Install RDP${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo apt-get -y install xrdp
sudo /etc/init.d/xrdp start

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Install Ropper${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo pip3 install ropper

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Retrieve Exercice${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
cd /home/pi
mkdir "Desktop"
cd /home/pi/Desktop/
mkdir "exercice"
cd "$HOME"
git clone https://github.com/serma-safety-security/Training_Ressources.git
rsync -aR Training_Ressources "$HOME"/Downloads/
rsync -a "$HOME"/Downloads/Training_Ressources/exercices/* "$HOME"/Desktop/exercice/
chmod +x "$HOME"/Desktop/exercice/1_bof/payload.pl
chmod +x "$HOME"/Desktop/exercice/2_sdr/receive_data
chmod +x "$HOME"/Desktop/exercice/2_sdr/send_data
chmod +x "$HOME"/Desktop/exercice/3_ctf/refinium
rm -rf Training_Ressources/ Downloads/Training_Ressources/
cp -r /var/lib/gems/2.5.0/gems/hardsploit_gui-2.5.0/lib/hardsploit-api /home/pi/Desktop/exercice/1_hw_hacking_101

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Visuals${NC}\n"
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

wget -q https://raw.githubusercontent.com/serma-safety-security/Training_Ressources/master/installation/serma_wallpaper.png -o /home/pi/Pictures/serma_wallpaper.png
pcmanfm --set-wallpaper /home/pi/serma_wallpaper.png

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Spring cleaning${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo apt autoremove

printf "${Green}══════════════════════════════════${NC}\n"
printf "${Green}Config done. Rebooting now...${NC}\n"
printf "${Green}══════════════════════════════════${NC}\n"
sudo reboot
