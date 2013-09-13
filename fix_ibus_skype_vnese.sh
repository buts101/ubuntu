#!/bin/bash
# Help ibus-unikey recognizes Skype
# This script does those steps that were described in http://wikilinux.vn/fixed-sua-loi-go-tieng-viet-ibus-unikey-tren-skype-ubuntu-13-04/

sudo apt-get install ibus-qt4

sudo cp /etc/X11/xinit/xinput.d/ibus{,.backup}

sudo sed -i 's/GTK_IM_MODULE=xim/GTK_IM_MODULE=ibus/g' /etc/X11/xinit/xinput.d/ibus
sudo sed -i 's/QT_IM_MODULE=xim/QT_IM_MODULE=ibus/g' /etc/X11/xinit/xinput.d/ibus
sudo sed -i 's/CLUTTER_IM_MODULE=xim/CLUTTER_IM_MODULE=ibus/g' /etc/X11/xinit/xinput.d/ibus
sudo sed -i 's/DEPENDS="ibus, ibus-gtk|ibus-qt4|ibus-clutter"/DEPENDS="ibus, ibus-gtk, ibus-qt4, ibus-clutter"/g' /etc/X11/xinit/xinput.d/ibus

im-switch -s ibus

sudo killall skype

killall ibus-daemon
sleep 2
ibus-daemon &

echo "
Login to Skype and check if this works!
"
