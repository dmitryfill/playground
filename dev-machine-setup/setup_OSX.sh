#!/bin/bash
clear

# Make hidden files visible in Finder
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

# Get Git 1.9.2
curl -L http://softlayer-dal.dl.sourceforge.net/project/git-osx-installer/git-1.9.2-intel-universal-snow-leopard.dmg -o git-1.9.2-intel-universal-snow-leopard.dmg
hdiutil mount ~/Downloads/git-1.9.2-intel-universal-snow-leopard.dmg

# 1. Download sublime Text 3 beta (on current moment, Feb 25, 2014 - build 3059)
cd ~/Downloads
pwd
curl -L http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203059.dmg -o Sublime\ Text\ Build\ 3059.dmg
hdiutil mount ~/Downloads/Sublime\ Text\ Build\ 3059.dmg
sudo cp -Rf /Volumes/Sublime\ Text/Sublime\ Text.app /Applications

# 1.1 Create sublime text sym link
sudo ln -sf /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/bin/subl
# rm /usr/bin/subl 
# ls -lah /usr/bin/ |grep subl

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

# 2. Setup bash profile and aliases
touch ~/.bash_profile

cat << EOF >> ~/.bash_profile
#!/bin/bash

if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# Setting $PATH
EOF

touch ~/.bashrc

cat << EOF >> ~/.bashrc
#!/bin/bash

# Setup Aliases
alias l='ls -lahG'
alias ll='ls -lahGF'
alias cls='clear'
alias md='mkdir'
alias ns='sudo lsof -i -n -P|grep LISTEN'

gup() { clear; pwd -P; git remote -v; git status -v; git branch -v; git remote -v update; git pull --all -v; }

gettxt() { curl -i -H "Accept: text/plain" -X GET $*; printf '\n\n'; }
getjson() { curl -i -H "Accept: application/json" -X GET $*; printf '\n\n'; }
postjson() { curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X POST $*; printf '\n\n'; }

ff() { find . -iname "$*" -print; }
rmr() { find . -type f -iname "$*" -delete; }

# Setting $PATH
EOF

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

# 3. Install IntelliJ IDEA 13.1
cd ~/Downloads
pwd
curl -L http://download-ln.jetbrains.com/idea/ideaIU-135.1019-jdk-bundled.dmg -o ideaIU-135.1019-jdk-bundled.dmg
hdiutil mount ~/Downloads/ideaIU-135.1019-jdk-bundled.dmg
sudo cp -Rfv /Volumes/IntelliJ\ IDEA\ 13/IntelliJ\ IDEA\ 13.app /Applications

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

# 4. Install Charles proxy
# cd ~/Downloads
# pwd
# curl -L http://www.charlesproxy.com/assets/release/3.8.3/charles-proxy-3.8.3a-applejava.dmg -o charles-proxy-3.8.3a-applejava.dmg
# yes | hdiutil mount -nobrowse -noautoopen -quiet ~/Downloads/charles-proxy-3.8.3a-applejava.dmg
# sudo cp -Rf /Volumes/IntelliJ\ IDEA\ 13\ EAP/IntelliJ\ IDEA\ 13\ EAP.app /Applications

# Sometimes you need to raise num of processes & number of open files for build tools to run faster
# http://www.lecentre.net/blog/archives/686
# http://superuser.com/questions/508227/mac-os-x-10-7-4-process-limit
# https://discussions.apple.com/thread/1154144?tstart=0
cat /etc/launchd.conf; cat /etc/sysctl.conf; sysctl -a|grep maxproc; ulimit -a;

sudo cat << EOF >> /etc/launchd.conf
limit maxproc 1536 2048
limit maxfiles 10240 65536
EOF

cat /etc/launchd.conf; cat /etc/sysctl.conf; sysctl -a|grep maxproc; ulimit -a;

echo $'\n\tReboot required for settings in /etc/launchd.conf to take an effect...\n\n'

img2iso(){
	# original script taken from here:
	## http://forums.appleinsider.com/t/159955/howto-create-bootable-mavericks-iso
	
}