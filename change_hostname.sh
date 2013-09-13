#!/bin/bash
# Change hostname in Ubuntu

# get the OLD_NAME
OLD_NAME=$(hostname)

# ask for new name
echo "The current hostname is: $OLD_NAME"
read -p "Enter new hostname: " NEW_NAME

# edit the /etc/hostname
sudo sed -i "s/$OLD_NAME/$NEW_NAME/g" /etc/hostname

# replace OLD_NAME by NEW_NAME in /etc/hosts
sudo sed -i "s/$OLD_NAME/$NEW_NAME/g" /etc/hosts

# change hostname
sudo hostname $NEW_NAME

echo "
Type hostname to check the new name is okay.
"
