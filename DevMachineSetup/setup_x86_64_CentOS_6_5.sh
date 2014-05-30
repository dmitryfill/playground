#!/bin/bash

# TODO - Break all into functions and make it accept cmd args

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
# 1. Download sublime Text 3 beta (on current moment, Jan 25, 2014 - build 3059)
cd ~/Downloads
pwd
wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3059_x64.tar.bz2
tar -xf sublime_text_3_build_3059_x64.tar.bz2
cp -f ~/Downloads/sublime_text_3/sublime_text.desktop ~/Desktop/
sed -i "s/Icon=sublime-text/Icon=\/opt\/sublime_text\/Icon\/256x256\/sublime-text.png/g" ~/Desktop/sublime_text.desktop
chmod 755 ~/Desktop/sublime_text.desktop
sudo mv -f ~/Downloads/sublime_text_3 /opt/sublime_text

# 1.1 Create a symlink
sudo ln -snf /opt/sublime_text/sublime_text /usr/bin/subl

# 1.2 Install Package Control, and another helpful packages
wget https://sublime.wbond.net/Package%20Control.sublime-package
mkdir -p --verbose ~/.config/sublime-text-3/Installed\ Packages/
mv -f ~/Downloads/Package\ Control.sublime-package ~/.config/sublime-text-3/Installed\ Packages/

read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

# 2. Download and install IntelliJ (on current moment, Jan 25, 2013 - 13 EAP)
cd ~/Downloads
pwd
#wget http://download.jetbrains.com/idea/ideaIU-13.0.2.tar.gz
#wget http://download.jetbrains.com/idea/ideaIU-13.1.1.tar.gz
wget http://download.jetbrains.com/idea/ideaIU-135.815.tar.gz

#tar -xzvf ideaIU-13.1.1.tar.gz
tar -xzvf ideaIU-135.815.tar.gz
#sudo mv -fv ~/Downloads/idea-IU-135.480 /opt/
sudo mv -fv ~/Downloads/idea-IU-135.815 /opt/

# 2.1 Create a symlink
#sudo ln -snf /opt/idea-IU-135.480/bin/idea.sh /usr/bin/idea
sudo ln -snf /opt/idea-IU-135.815/bin/idea.sh /usr/bin/idea 

rm -fv ~/Desktop/idea.desktop
# 2.2 Create a Desktop shortcut
cat << EOF >> ~/Desktop/idea.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA 13.1
GenericName=Text Editor
Comment=Sophisticated text editor for code, markup and prose
Exec=/usr/bin/idea %F
Terminal=false
MimeType=text/plain;
Icon=/opt/idea-IU-135.815/bin/idea.png
Categories=TextEditor;Development;
StartupNotify=true
Actions=Window;Document;
EOF

chmod 755 ~/Desktop/idea.desktop

# 3. Install latest Git (1.9.0 at this moment)
# Need to install following packages to be able to compile
sudo yum install -y asciidoc zlib-devel perl-ExtUtils-Embed gettext xmlto
 ~/Downloads
pwd
wget https://git-core.googlecode.com/files/git-1.9.0.tar.gz
tar -xzvf git-1.9.0.tar.gz
cd git-1.9.0
make configure
./configure --prefix=/usr
make all doc
sudo make install install-doc install-html

git config --global -l
# configure Git aliases and gitignore_global
# TODO - Automate username and email inputs...
# git config --global user.name "$USER"
# git config --global user.email "$USEREMAIL@gmail.com"
git config --global alias.ci "commit -a -v"
git config --global alias.co "checkout"
git config --global alias.st "status -v"
git config --global alias.stat "status -v"
git config --global alias.smi "submodule init"
git config --global alias.sms "submodule status"
git config --global alias.smu "submodule update"
git config --global alias.br branch
git config --global alias.wdiff "diff --color-words"
# If you have a Sublime Text hooked with subl alias or symlink:
git config --global core.editor subl
git config --global merge.summary true

cp -vf ../.gitignore ~/.gitignore_global
#touch ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

# open ~/.gitignore_global in Sublime
# subl ~/.gitignore_global
# Paste al from here and save:
# https://raw.githubusercontent.com/dmitryfill/Playground/master/.gitignore
git config --global -l

# git config --local user.name "Xxx Xxx"
# git config --local user.email xxx@gmail.com
git config --local -l


# 4. Install Ant & Ivy
cd ~/Downloads
pwd
wget http://apache.mirrors.hoobly.com//ant/binaries/apache-ant-1.9.3-bin.tar.gz
tar -xzvf apache-ant-1.9.3-bin.tar.gz
sudo mv -fv ~/Downloads/apache-ant-1.9.3/ /opt/
sudo ln -snf /opt/apache-ant-1.9.3/bin/ant /usr/bin/ant
cd ~/Downloads
pwd
wget http://archive.apache.org/dist/ant/ivy/2.3.0/apache-ivy-2.3.0-bin-with-deps.tar.gz
tar -xzvf apache-ivy-2.3.0-bin-with-deps.tar.gz
sudo mv -fv ~/Downloads/apache-ivy-2.3.0/ /opt/
cp /opt/apache-ivy-2.3.0/ivy-2.3.0.jar /opt/apache-ant-1.9.3/lib/
cp /opt/apache-ivy-2.3.0/ivy-2.3.0.jar /opt/apache-ant-1.9.3/lib/ivy.jar
# sudo ln -snf /opt/apache-ivy-2.3.0/ivy-2.3.0.jar /usr/bin/ivy


# 5. Install Gradle
cd ~/Downloads
pwd
# wget http://services.gradle.org/distributions/gradle-1.11-all.zip
wget https://services.gradle.org/distributions/gradle-1.12-all.zip
# unzip gradle-1.11-all.zip
unzip gradle-1.12-all.zip
sudo mv -fv gradle-1.12 /opt/
sudo ln -snf /opt/gradle-1.12/bin/gradle /usr/bin/gradle

# 6. Install Oracle Java 7 & Java 8
install_java7(){
	cd ~/Downloads
	pwd
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.rpm"
	sudo rpm -Uvh jdk-7u55-linux-x64.rpm
}

install_java8(){
	# JDK 8
	cd ~/Downloads
	pwd
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-linux-x64.rpm"
	sudo rpm -Uvh jdk-8u5-linux-x64.rpm
}

install_maven{
	cd ~/Downloads
	pwd
	wget http://apache.osuosl.org/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz
	tar -xzvf apache-maven-3.2.1-bin.tar.gz
	sudo mv -v apache-maven-3.2.1 /opt/
	sudo ln -snf /opt/apache-maven-3.2.1/bin/mvn /usr/bin/mvn

	# http://maven.apache.org/guides/mini/guide-3rd-party-jars-local.html
	# mvn install:install-file -Dfile=<path-to-file> -DgroupId=<group-id> -DartifactId=<artifact-id> -Dversion=<version> -Dpackaging=<packaging>
	# mvn install:install-file -Dfile=<path-to-file> -DpomFile=<path-to-pomfile>

	# http://download.oracle.com/otndocs/jcp/7542-jms-1.1-fr-doc-oth-JSpec/
	# http://download.oracle.com/otn-pub/jcp/7542-jms-1.1-fr-doc-oth-JSpec/jms-1_1-fr-apidocs.zip
	# mvn install:install-file -Dfile=/home/df/Downloads/jms1.1/jms/1.1/jms.jar -DpomFile=/home/df/Downloads/jms1.1/jms/1.1/jms-1.1.pom
}

install_java7
install_java8