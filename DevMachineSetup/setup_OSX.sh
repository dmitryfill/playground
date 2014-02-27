# Install Sublime Text
wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203059.dmg
hdiutil mount ~/Downloads/Sublime\ Text\ Build\ 3059.dmg
sudo cp -R /Volumes/Sublime\ Text/Sublime\ Text.app /Applications
# Create sublime text sym link
sudo ln -sf /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/bin/subl
# rm /usr/bin/subl 
# ls -lah /usr/bin/ |grep subl
touch ~/.bash_profile
touch ~/.bashrc
