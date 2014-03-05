#!/bin/bash
clear
# 1. Download sublime Text 3 beta (on current moment, Feb 25, 2014 - build 3059)
cd ~/Downloads
pwd
curl -L http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203059.dmg -o Sublime\ Text\ Build\ 3059.dmg
hdiutil mount ~/Downloads/Sublime\ Text\ Build\ 3059.dmg
sudo cp -Rf /Volumes/Sublime\ Text/Sublime\ Text.app /Applications

# Create sublime text sym link
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

# Setting $PATH
EOF

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

# 3. Install IntelliJ IDEA 13
cd ~/Downloads
pwd
curl -L http://download-ln.jetbrains.com/idea/ideaIU-13.0.2.dmg -o ideaIU-13.0.2.dmg
hdiutil mount ~/Downloads/ideaIU-13.0.2.dmg
sudo cp -Rf /Volumes/IntelliJ\ IDEA\ 13/IntelliJ\ IDEA\ 13.app /Applications

# 3. Install IntelliJ IDEA 13.1 EAP
cd ~/Downloads
pwd
curl -L http://download.jetbrains.com/idea/ideaIU-134.1342-jdk-bundled.dmg -o ideaIU-134.1342-jdk-bundled.dmg
hdiutil mount ~/Downloads/ideaIU-134.1342-jdk-bundled.dmg
sudo cp -Rf /Volumes/IntelliJ\ IDEA\ 13\ EAP/IntelliJ\ IDEA\ 13\ EAP.app /Applications

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

# 4. Install Charles proxy
# cd ~/Downloads
# pwd
# curl -L http://www.charlesproxy.com/assets/release/3.8.3/charles-proxy-3.8.3a-applejava.dmg -o charles-proxy-3.8.3a-applejava.dmg
# yes | hdiutil mount -nobrowse -noautoopen -quiet ~/Downloads/charles-proxy-3.8.3a-applejava.dmg
# sudo cp -Rf /Volumes/IntelliJ\ IDEA\ 13\ EAP/IntelliJ\ IDEA\ 13\ EAP.app /Applications


