#!/bin/bash
# 0. Check if user has sudo permissions, if not exit
## making sure script is not being run under root, if it does just exit
if [[ $UID -eq 0 ]]
then 
    echo 'do NOT run this script under root!'
    exit 1
fi
## invalidate any cached sudo, prompt for password
sudo -kk
sudo whoami >/dev/null
## actually checks if sudo credentials were cached successfully
if [[ $(sudo whoami) == 'root' ]] 
then
    echo 'great! user has sudo!'
else
    echo 'Seems like user does not have sudo!'
    echo 'Please visit this page to read how to grant permissions to user:'
    echo 'https://www.digitalocean.com/community/articles/how-to-edit-the-sudoers-file-on-ubuntu-and-centos'
    exit 1
fi
# Pretty good explanation on how to make your user account to be in the sudoers file
# sudo visudo
# https://www.digitalocean.com/community/articles/how-to-edit-the-sudoers-file-on-ubuntu-and-centos

# Script to configure Dev Machine and install tools for x64 platform
clear
sudo yum -y update
sudo yum -y upgrade

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

clear
# 1. Get Cloudera CDH 5
cd ~/Downloads
pwd
wget http://archive.cloudera.com/cm5/installer/latest/cloudera-manager-installer.bin
chmod u+x cloudera-manager-installer.bin
# sudo ./cloudera-manager-installer.bin

## Disable SELinux
# sudo setenforce 0
# nano /etc/selinux/config

clear
# 2. Get Kafka
cd ~/Downloads
pwd
wget

clear
# 2. Get Splunk
cd ~/Downloads
pwd
wget -O splunk-6.0.2-196940-Linux-x86_64.tgz 'http://www.splunk.com/page/download_track?file=6.0.2/splunk/linux/splunk-6.0.2-196940-Linux-x86_64.tgz&ac=&wget=true&name=wget&platform=Linux&architecture=x86_64&version=6.0.2&product=splunk&typed=release'
tar xvzf splunk-6.0.2-196940-Linux-x86_64.tgz
sudo mv splunk /opt/

sudo ./opt/splunk/bin/splunk start --

mkdir -p ~/git
cd ~/git
pwd
git clone https://github.com/splunk/splunk-sdk-java.git
