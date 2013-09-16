#!/bin/bash
# This script will copy all the apt-cache db and downloaded packages from a local server.
# This will save ton of time and bandwidth.
# We haf troubles with fpt and other repo from Vietnam for a while then we change to use the main server
# to download packages from. The speed is limitted but more updated.

# Require to run this script as root
if [ "$(id -u)" != "0" ]; then
    echo "
    Please run this script with sudo permission.
    Try: sudo ./ubuntu_after_fresh_install.sh"
    exit 1
fi

# #########################################
# # Copy downloaded files from local server
# #########################################

# # Clean all downloaded the packages if exist
# apt-get clean
# rm -rf /var/lib/apt/lists/*

# # Copy the package list db to /var/lib/apt/lists/
# wget --no-verbose --no-parent --recursive --level=1 --no-directories --reject "index.html*",gif,"aptdb" http://192.168.1.33/aptdb/ -P /var/lib/apt/lists/

# # Copy the downloaded packages to /var/cache/apt/archives/
# wget --no-verbose --no-parent --recursive --level=1 --no-directories --reject "index.html*",gif,"apt" http://192.168.1.33/apt/ -P /var/cache/apt/archives/

#####################
# Add nessessary repo
#####################

# We can install skype, adobe-flashplugin, etc from this repo
apt-add-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner" -y

# To upgrade libreoffice newest version
add-apt-repository ppa:libreoffice/ppa -y

# Google-chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

# Indicator multiload
add-apt-repository ppa:indicator-multiload/stable-daily -y

###################################
# Switch to update from main server
###################################

# Create a backup
cp /etc/apt/sources.list{,.backup}

# Change to main server
sed -i 's|http:\/\/.*ubuntu|http://archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list

# Fetch the db then upgrade the distro
apt-get update

apt-get dist-upgrade -y

####################################################
# Install neccessary packages like pidgin, vlc, etc
####################################################
INTERNET="pidgin google-chrome-stable"
JAPANESE_FONT="ibus-anthy ttf-takao-mincho ttf-takao fonts-takao"
DEV_TOOLS="vim git"
TERMINAL="terminator guake"
MEDIA="vlc"
OFFICE="ibus-unikey ttf-mscorefonts-installer" 
OTHER="unrar-free unrar openssh-server indicator-multiload"

# Agree with Microsoft lisence when using msttcorefonts
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

apt-get install -y $INTERNET $DEV_TOOLS $TERMINAL $MEDIA $OFFICE $OTHER $JAPANESE_FONT

# If we install skype first then the system will ask can not install skype-bin?
apt-get install skype-bin -y
apt-get install skype -y

# Restart openssh service
/etc/init.d/ssh start
