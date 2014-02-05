#!/bin/bash

# Script to configure Dev Machine and install tools for x64 platform
clear
yum -y update
yum -y upgrade

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

clear
# 1. Download sublime Text 3 beta (on current moment, Jan 25, 2014 - build 3059)
cd ~/Downloads
pwd
wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3059_x64.tar.bz2
tar -xf sublime_text_3_build_3059_x64.tar.bz2
cp -f ~/Downloads/sublime_text_3/sublime_text.desktop ~/Desktop/
sed -i "s/Icon=sublime-text/Icon=\/opt\/sublime_text\/Icon\/256x256\/sublime-text.png/g" ~/Desktop/sublime_text.desktop
chmod 777 ~/Desktop/sublime_text.desktop
sudo mv -f ~/Downloads/sublime_text_3 /opt/sublime_text
# 1.1 Install Package Control
wget https://sublime.wbond.net/Package%20Control.sublime-package
mv -f ~/Downloads/Package\ Control.sublime-package ~/.config/sublime-text-3/Installed\ Packages/

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

# 2. Download and install IntelliJ (on current moment, Jan 25, 2013 - 13 EAP)
cd ~/Downloads
pwd
wget http://download.jetbrains.com/idea/ideaIU-13.0.2.tar.gz
tar -xzvf ideaIU-13.0.2.tar.gz
