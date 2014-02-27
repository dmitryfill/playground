#!/bin/bash
clear
# 1. Download sublime Text 3 beta (on current moment, Feb 25, 2014 - build 3059)
cd ~/Downloads
pwd
wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203059.dmg
hdiutil mount ~/Downloads/Sublime\ Text\ Build\ 3059.dmg
sudo cp -R /Volumes/Sublime\ Text/Sublime\ Text.app /Applications

# Create sublime text sym link
sudo ln -sf /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/bin/subl
# rm /usr/bin/subl 
# ls -lah /usr/bin/ |grep subl
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