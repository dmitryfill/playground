#!/bin/bash

# Script to configure Dev Machine and install tools for x64 platform

# 1. Download sublime Text 3 beta (on current moment, Jan 25, 2014 - build 3059)
cd ~/Downloads
pwd
wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3059_x64.tar.bz2
tar -xvf sublime_text_3_build_3059_x64.tar.bz2
cp -f ~/Downloads/sublime_text_3/sublime_text.desktop ~/Desktop/
su mv -f ~/Downloads/sublime_text_3 /opt/sublime_text

# 2. Download and install IntelliJ (on current moment, Jan 25, 2013 - 13 EAP)
cd ~/Downloads
pwd
wget http://download.jetbrains.com/idea/ideaIU-13.0.2.tar.gz
tar -xzvf ideaIU-13.0.2.tar.gz
