#!/bin/bash

# This script created based on few sources:
# http://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/
# https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Virtualization/3.0/html/Evaluation_Guide/Evaluation_Guide-Create_RHEL_Template.html
# http://libguestfs.org/virt-sysprep.1.html

# Print version of OS
cat /etc/redhat-release

# 0. Install latest updates
yum -y update && yum -y upgrade

# 1. Clean Yum cache
# http://www.linuxcommand.org/man_pages/yum8.html
yum clean all

# 2. Force the logs to rotate
logrotate –f /etc/logrotate.conf
rm –f /var/log/*-???????? /var/log/*.gz

# 3. Clear the audit log & wtmp
cat /dev/null > /var/log/audit/audit.log
cat /dev/null > /var/log/wtmp

# 4. Remove the traces of the template MAC address and UUIDs
ifdown eth0
sed -i.bak '/^\(HWADDR\|UUID\)=/d' /etc/sysconfig/network-scripts/ifcfg-eth0
ifup eth0

# 5. Remove the udev persistent device rules
# http://ss64.com/bash/sed.html
# cat /etc/udev/rules.d/70-persistent-net.rules | grep -v eth0 > /etc/udev/rules.d/70-persistent-net.rules
#sed -i.bak '/eth0/d' /etc/udev/rules.d/70-persistent-net.rules
rm -f /etc/udev/rules.d/70*

# 6. Clean /tmp out
rm –rf /tmp/*
rm –rf /var/tmp/*

# 7. Remove the SSH host keys
rm –f /etc/ssh/*key*

# 8. Remove the root user’s shell history
rm -f ~root/.bash_history
unset HISTFILE

# 9. Flag the system for reconfiguration
touch /.unconfigured

# 10. Reset root password to blank and enforce to be changed on first login
usermon -p "" root
chage -d 0 root

# 11. PowerOff
poweroff


# 12. Zero out all free space
# Determine the version of RHEL

# FileSystem='grep ext /etc/mtab| awk -F" " ''{ print $2 }'''

# for i in $FileSystem
# do
#        echo $i
#        number='df -B 512 $i | awk -F" " ''{print $3}'' | grep -v Used'
#        echo $number
#        percent=$(echo 'scale=0; $number * 98 / 100' | bc )
#        echo $percent
#        dd count='echo $percent' if=/dev/zero of='echo $i'/zf
#        sync
#        sleep 15
#        rm -f $i/zf
# done

# VolumeGroup='vgdisplay | grep Name | awk -F  '{ print $3 }''

# for j in $VolumeGroup
# do
#        echo $j
#        lvcreate -l 'vgdisplay $j | grep Free | awk -F" " ''{ print $5 }''' -n zero $j
#        if [ -a /dev/$j/zero ]; then
#                cat /dev/zero > /dev/$j/zero
#                sync
#                sleep 15
#                lvremove -f /dev/$j/zero
#        fi
# done


