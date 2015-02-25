#!/bin/bash
clear;

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
    printf '\nGreat! User has sudo, continue...\n\n'
else
    echo 'Seems like user does not have sudo!'
    echo 'Please visit this page to read how to grant permissions to user:'
    echo 'https://www.digitalocean.com/community/articles/how-to-edit-the-sudoers-file-on-ubuntu-and-centos'
    exit 1
fi
# Pretty good explanation on how to make your user account to be in the sudoers file
# sudo visudo
# https://www.digitalocean.com/community/articles/how-to-edit-the-sudoers-file-on-ubuntu-and-centos

# read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key
sudo yum groupinstall -y "Development Tools"
sudo yum install -y wget net-tools curl-devel perl-devel perl-ExtUtils-Embed python-devel java-1.7.0-openjdk-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 apr-devel sqlite-devel db4-devel subversion-devel docker nodejs npm

# clear;

# 1. Download sublime Text 3 beta (on current moment, Jan 25, 2014 - build 3059)
install_sublime(){
	cd ~/Downloads
	pwd
	# wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3059_x64.tar.bz2
	# tar -xf sublime_text_3_build_3059_x64.tar.bz2
	wget http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3065_x64.tar.bz2
	tar -xf sublime_text_3_build_3065_x64.tar.bz2

	sudo mv -f ~/Downloads/sublime_text_3 /opt/
	sudo ln -snf /opt/sublime_text_3 /opt/sublime_text

	cp -f /opt/sublime_text_3/sublime_text.desktop ~/Desktop/
	sed -i "s/Icon=sublime-text/Icon=\/opt\/sublime_text_3\/Icon\/256x256\/sublime-text.png/g" ~/Desktop/sublime_text.desktop
	chmod 755 ~/Desktop/sublime_text.desktop

	sudo ln -snf /opt/sublime_text_3/sublime_text /usr/bin/subl

	# 1.1 Install Package Control, and another helpful packages
	wget https://sublime.wbond.net/Package%20Control.sublime-package
	mkdir -p --verbose ~/.config/sublime-text-3/Installed\ Packages/
	mv -f ~/Downloads/Package\ Control.sublime-package ~/.config/sublime-text-3/Installed\ Packages/
}

# read -t30 -n1 -r -p "Press any key in the next 30 seconds..." key

# 2. Download and install IntelliJ (on current moment, Aug 28, 2014 - 14 EAP)
install_idea(){

cd ~/Downloads;
pwd;
#wget http://download.jetbrains.com/idea/ideaIU-13.0.2.tar.gz
#wget http://download.jetbrains.com/idea/ideaIU-13.1.1.tar.gz
# wget http://download.jetbrains.com/idea/ideaIU-135.815.tar.gz
# wget http://download.jetbrains.com/idea/ideaIU-138.1696.2.tar.gz
# wget http://download.jetbrains.com/idea/ideaIU-138.2210.3.tar.gz;
# wget http://download.jetbrains.com/idea/ideaIU-14-PublicPreview.tar.gz
# wget http://download.jetbrains.com/idea/ideaIU-139.223.8.tar.gz;
# wget -O - http://download.jetbrains.com/idea/ideaIU-139.463.4.tar.gz | tar zxf -;
# wget -O - http://download.jetbrains.com/idea/ideaIU-14.0.2.tar.gz | tar zxf -;
# wget -O - http://download.jetbrains.com/idea/ideaIU-139.791.2.tar.gz | tar zxf -;
# wget -O - http://download.jetbrains.com/idea/ideaIU-14.0.3.tar.gz | tar zxf -;
# wget -O - http://download.jetbrains.com/idea/ideaIU-140.2493.5.tar.gz | tar zxf -;
wget -O - http://download.jetbrains.com/idea/ideaIU-140.2683.2.tar.gz | tar zxf -;

# tar -xzvf ideaIU-13.1.1.tar.gz
# tar -xzvf ideaIU-135.815.tar.gz
# tar -xzvf ideaIU-138.1696.2.tar.gz
# tar -xzvf ideaIU-138.2210.3.tar.gz;
# tar -xzvf ideaIU-14-PublicPreview.tar.gz;
# tar -xzvf ideaIU-139.223.8.tar.gz;
# tar -xzvf ideaIU-139.463.4.tar.gz
# sudo mv -fv ~/Downloads/idea-IU-135.480 /opt/
# sudo mv -fv ~/Downloads/idea-IU-135.815 /opt/
# sudo mv -fv ~/Downloads/idea-IU-138.1696.2 /opt/
# sudo mv -fv ~/Downloads/idea-IU-138.2458.8 /opt/;
# sudo mv -fv ~/Downloads/idea-IU-139.223.8 /opt/;
# sudo mv -fv ~/Downloads/idea-IU-139.463.4 /opt/;
# sudo mv -fv ~/Downloads/idea-IU-139.659.2 /opt/;
# sudo mv -fv ~/Downloads/idea-IU-139.791.2 /opt/;
# sudo mv -fv ~/Downloads/idea-IU-139.1117.1 /opt/;
# sudo mv -fv ~/Downloads/idea-IU-140.2493.5 /opt/;
sudo mv -fv ~/Downloads/idea-IU-140.2683.2 /opt/;

# 2.1 Create a symlink
#sudo ln -snf /opt/idea-IU-135.480/bin/idea.sh /usr/bin/idea
#sudo ln -snf /opt/idea-IU-135.815/bin/idea.sh /usr/bin/idea 
#sudo ln -snf /opt/idea-IU-138.1696.2/bin/idea.sh /usr/bin/idea
#sudo ln -snf /opt/idea-IU-138.1696.2 /opt/idea14 

# sudo ln -snf /opt/idea-IU-138.2210.3/bin/idea.sh /usr/bin/idea;
# sudo ln -snf /opt/idea-IU-138.2210.3 /opt/idea14;

# sudo ln -snf /opt/idea-IU-138.2458.8 /opt/idea14;
# sudo ln -snf /opt/idea-IU-139.223.8 /opt/idea14;
# sudo ln -snf /opt/idea-IU-139.463.4 /opt/idea14;
# sudo ln -snf /opt/idea-IU-139.659.2 /opt/idea14;
# sudo ln -snf /opt/idea-IU-139.1117.1 /opt/idea14;
# sudo ln -snf /opt/idea-IU-140.2493.5 /opt/idea14;
sudo ln -snf /opt/idea-IU-140.2683.2 /opt/idea14;

# sudo ln -snf /opt/idea-IU-138.2458.8/bin/idea.sh /usr/bin/idea;
sudo ln -snf /opt/idea14/bin/idea.sh /usr/bin/idea;

rm -fv ~/Desktop/idea14.desktop;
# 2.2 Create a Desktop shortcut
cat << EOF >> ~/Desktop/idea14.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA 14 EAP
GenericName=Text Editor
Comment=Sophisticated text editor for code, markup and prose
Exec=/usr/bin/idea %F
Terminal=false
MimeType=text/plain;
Icon=/opt/idea14/bin/idea.png
Categories=TextEditor;Development;IDE;
StartupNotify=true
Actions=Window;Document;
EOF

chmod 755 ~/Desktop/idea14.desktop;

mkdir -p ~/.IntelliJIdea14/config/fileTemplates/includes
## Includes:
cat << EOF >> ~/.IntelliJIdea14/config/fileTemplates/includes/File\ Header.java
/**
 * Created by \${USER} on \${YEAR}-\${MONTH}-\${DAY}.
 * Package: \${PACKAGE_NAME}
 * Project: \${PROJECT_NAME}
 * File: \${NAME}.java
 * ...
 * Copyright (c) \${YEAR} Company, Inc. All rights reserved.
 */
EOF

sudo cp -v ~/Desktop/idea14.desktop /usr/share/applications/
}

# 3. Install latest Git (2.1.0 at this moment)
install_git(){
	if [ -z $(yum repolist|grep -i epel) ]; then
		printf 'Installing EPEL Repository...'
		adding_epel_repo;
	fi

	~/Downloads
	pwd

	# sudo yum -y --enablerepo=*epel* 
	# sudo yum install docbook2X

	# Need to install following packages to be able to compile
	sudo yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils asciidoc xmlto docbook2X docbook2x-texi
	# docbook2x-texi
	# wget http://tcpdiag.dl.sourceforge.net/project/docbook2x/docbook2x/0.8.8/docbook2X-0.8.8.tar.gz
	# tar -xzvf docbook2X-0.8.8.tar.gz
	# sudo mv -fv docbook2X-0.8.8 /opt/
	# sudo ln -s /opt/docbook2X-0.8.8/bin/ /usr/bin/docbook2x-texi
	sudo ln -snf /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi

	# wget https://git-core.googlecode.com/files/git-1.9.0.tar.gz
	wget https://www.kernel.org/pub/software/scm/git/git-2.1.0.tar.gz
	# tar -xzvf git-1.9.0.tar.gz
	tar -xzvf git-2.1.0.tar.gz
	sudo mv -fv git-2.1.0 /opt/
	# cd git-1.9.0
	cd /opt/git-2.1.0/

	make configure
	./configure --prefix=/usr
	make all doc
	sudo make install install-doc install-html install-info

	# make prefix=/usr all doc info ;# as yourself
	# sudo make prefix=/usr install install-doc install-html install-info ;# as root

	git config --global -l
	# configure Git aliases and gitignore_global
	# TODO - Automate username and email inputs...
	# git config --global user.name "$USER"
	# git config --global user.email "$USEREMAIL@gmail.com"

	# If you have a Sublime Text hooked with subl alias or symlink:
	git config --global core.editor subl
	git config --global merge.summary true
	git config --global rerere.enabled true

	git config --global alias.br "branch -v"
	git config --global alias.c "checkout -f"
	git config --global alias.cfg "config -l"
	git config --global alias.cfgg "config --global -l"
	git config --global alias.cfgl "config --local -l"
	git config --global alias.ci "commit -a -v"
	git config --global alias.co "checkout"
	git config --global alias.dc "diff --cached"
	git config --global alias.df diff
	git config --global alias.lg "log -p"
	git config --global alias.ll "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat"
	git config --global alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit"
	git config --global alias.lola "log --graph --decorate --pretty=oneline --abbrev-commit --all"
	git config --global alias.ls "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate"
	git config --global alias.lsf "ls-files"
	git config --global alias.lsfe "ls-files -o -i --exclude-standard"
	git config --global alias.lt "log --graph --oneline --decorate --all"
	git config --global alias.revert "reset --hard"
	git config --global alias.smi "submodule init"
	git config --global alias.sms "submodule status"
	git config --global alias.smu "submodule update"
	git config --global alias.st "status"
	git config --global alias.stat "status -v"
	git config --global alias.wdiff "diff --color-words"

	wget https://raw.githubusercontent.com/dmitryfill/Playground/master/.gitignore -O ~/.gitignore_global 
	git config --global core.excludesfile ~/.gitignore_global

	git config --global -l

	# git config --local user.name "Xxx Xxx"
	# git config --local user.email xxx@gmail.com
	# git config --local -l
}

# 4. Install Ant & Ivy
install_ant_ivy(){
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
}


# 5. Install Gradle
install_gradle(){
	cd ~/Downloads
	pwd
	# wget http://services.gradle.org/distributions/gradle-1.11-all.zip
	# wget https://services.gradle.org/distributions/gradle-1.12-all.zip
	# wget https://services.gradle.org/distributions/gradle-2.0-all.zip
	wget https://services.gradle.org/distributions/gradle-2.1-all.zip
	# unzip gradle-1.11-all.zip
	# unzip gradle-1.12-all.zip
	# unzip gradle-2.0-all.zip
	unzip gradle-2.1-all.zip
	# sudo mv -fv gradle-1.12 /opt/
	sudo mv -fv gradle-2.1 /opt/
	# sudo ln -snf /opt/gradle-1.12/bin/gradle /usr/bin/gradle
	sudo ln -snf /opt/gradle-2.1/bin/gradle /usr/bin/gradle
}

# 6. Install Oracle Java 7 & Java 8
install_java7(){
	cd ~/Downloads
	pwd
	# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.rpm"
	# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.rpm";
	# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.rpm";
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.rpm";
	
	# sudo rpm -Uvh jdk-7u67-linux-x64.rpm;
	# sudo rpm -Uvh jdk-7u71-linux-x64.rpm;
	sudo rpm -Uvh jdk-7u75-linux-x64.rpm;

	# echo -e '3\n' | sudo alternatives --config java;

	### http://www.if-not-true-then-false.com/2010/install-sun-oracle-java-jdk-jre-7-on-fedora-centos-red-hat-rhel/
	# sudo alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_71/bin/java 200000;
	sudo alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_75/bin/java 200000;
	# sudo alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.7.0_67/bin/javaws 200000; 
	## Java Browser (Mozilla) Plugin 32-bit ##
	# sudo alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /usr/java/jdk1.7.0_67/jre/lib/i386/libnpjp2.so 200000; 
	## Java Browser (Mozilla) Plugin 64-bit ##
	# sudo alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/jdk1.7.0_67/jre/lib/amd64/libnpjp2.so 200000;

	## Install javac only if you installed JDK (Java Development Kit) package ##
	# sudo alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_67/bin/javac 200000;
	# sudo alternatives --install /usr/bin/jar jar /usr/java/jdk1.7.0_67/bin/jar 200000;

	# echo -e '3\n' | sudo alternatives --config java;
	alternatives_java_latest_install;
}

install_java8(){
	# JDK 8
	cd ~/Downloads
	pwd
	# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-linux-x64.rpm"
	# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jdk-8u20-linux-x64.rpm";
	# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.rpm";
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31-linux-x64.rpm";
	
	# sudo rpm -Uvh jdk-8u5-linux-x64.rpm
	# sudo rpm -Uvh jdk-8u20-linux-x64.rpm;
	# sudo rpm -Uvh jdk-8u25-linux-x64.rpm;
	sudo rpm -Uvh jdk-8u31-linux-x64.rpm;

	# echo -e '3\n' | sudo alternatives --config java;
	
	### http://www.if-not-true-then-false.com/2014/install-oracle-java-8-on-fedora-centos-rhel/
	# sudo alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_20/bin/java 200000;
	# sudo alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_25/bin/java 200000;
	sudo alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_31/bin/java 200000;
	# sudo alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.8.0_20/bin/javaws 200000; 
	## Java Browser (Mozilla) Plugin 32-bit ##
	# sudo alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /usr/java/jdk1.8.0_20/jre/lib/i386/libnpjp2.so 200000; 
	## Java Browser (Mozilla) Plugin 64-bit ##
	# sudo alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/jdk1.8.0_20/jre/lib/amd64/libnpjp2.so 200000;

	## Install javac only if you installed JDK (Java Development Kit) package ##
	# sudo alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_20/bin/javac 200000;
	# sudo alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_20/bin/jar 200000;

	alternatives_java_latest_install;
}

alternatives_java_latest_install(){
	
	sudo alternatives --remove /usr/bin/java java /usr/java/latest/bin/java 200000;
	sudo alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000;
	
	latestid=$(echo -e '\n'| sudo alternatives --config java |grep '/usr/java/latest/'| sed 's/^[+* \t]*//'|awk '{print $1}');
	
	# echo -e "$latestid\n";

	# echo -e '\n'| sudo alternatives --config java;

	if [ -z $latestid ]; then 
		printf 'Installing /usr/java/latest/...\n'; 
		break;
		### http://wiki.centos.org/HowTos/JavaRuntimeEnvironment
		sudo alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000;
		# sudo alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000;
		 
		## Java Browser (Mozilla) Plugin 32-bit ##
		# sudo alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /usr/java/latest/jre/lib/i386/libnpjp2.so 200000;
		## Java Browser (Mozilla) Plugin 64-bit ##
		# sudo alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/latest/jre/lib/amd64/libnpjp2.so 200000;
		 
		## Install javac only if you installed JDK (Java Development Kit) package ##
		# sudo alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000;
		# sudo alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 200000;
	fi

	latestid=$(echo -e '\n'| sudo alternatives --config java |grep '/usr/java/latest/'| sed 's/^[+* \t]*//'|awk '{print $1}');
	
	echo -e '\n\n'| sudo alternatives --config java;

	printf 'Setting default java to latest... ($latestid)';
	echo -e "$latestid\n\n"| sudo alternatives --config java; 
	# maxid=$(echo -e '\n'| sudo alternatives --config java |grep 'There are '| awk '{print $3}');
	printf '\n\n';
}

install_maven(){
	cd /Downloads/
	pwd
	# wget http://apache.osuosl.org/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz
	# wget http://apache.arvixe.com/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz
	# tar -xzvf apache-maven-3.2.1-bin.tar.gz
	# tar -xzvf apache-maven-3.2.3-bin.tar.gz
	# sudo mv -v apache-maven-3.2.1 /opt/
	# sudo mv -v apache-maven-3.2.3 /opt/
	# sudo ln -snf /opt/apache-maven-3.2.1/bin/mvn /usr/bin/mvn
	wget -O - http://psg.mtu.edu/pub/apache/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz | tar zxf -
	sudo mv -v apache-maven-3.2.3 /opt/
	sudo ln -snf /opt/apache-maven-3.2.3/bin/mvn /usr/bin/mvn

	# http://maven.apache.org/guides/mini/guide-3rd-party-jars-local.html
	# mvn install:install-file -Dfile=<path-to-file> -DgroupId=<group-id> -DartifactId=<artifact-id> -Dversion=<version> -Dpackaging=<packaging>
	# mvn install:install-file -Dfile=<path-to-file> -DpomFile=<path-to-pomfile>

	# http://download.oracle.com/otndocs/jcp/7542-jms-1.1-fr-doc-oth-JSpec/
	# http://download.oracle.com/otn-pub/jcp/7542-jms-1.1-fr-doc-oth-JSpec/jms-1_1-fr-apidocs.zip
	# mvn install:install-file -Dfile=/home/df/Downloads/jms1.1/jms/1.1/jms.jar -DpomFile=/home/df/Downloads/jms1.1/jms/1.1/jms-1.1.pom
}


print_help(){
	printf '\nUsage:\n';
	printf "$0 [option]\n\n";
	printf 'options:\n';
	printf '\t-y\tAssumes yes on all prompts, unattented mode\n\t\twill install default set of tools (IDEA, git, gradle, maven, etc)\n\n';
	printf '\t-h\tShows help\n';
	printf '\n\n';
	exit 0;
}

# How To Enable EPEL Repository in RHEL/CentOS 7/6/5?
# http://www.tecmint.com/how-to-enable-epel-repository-for-rhel-centos-6-5/

## RHEL/CentOS 7 64-Bit ##
# wget http://dl.fedoraproject.org/pub/epel/7/x86_64/epel-release-7-0.2.noarch.rpm
# wget http://linux.mirrors.es.net/fedora-epel//7/x86_64/epel-release-7-0.2.noarch.rpm
# wget http://mirror.metrocast.net/fedora/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm
# rpm -ivh epel-release-7-0.2.noarch.rpm

adding_epel_repo(){
	printf '\n\nChecking OS version...\n'
	cd ~/Downloads/
	pwd
	sudo yum install epel-release -y

	# if grep -q -i "release 6" /etc/redhat-release; then
	# 	printf 'Adding EPEL Repository for CentOS 6.x x86_64:\n\n';
	# 	## RHEL/CentOS 6.x 64-Bit ##
	# 	# wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm;
	# 	# rpm -ivh epel-release-6-8.noarch.rpm;
	# 	sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm;

	# elif grep -q -i "release 7" /etc/redhat-release; then
	# 	printf 'Adding EPEL Repository for CentOS 7.x x86_64:\n\n';
	# 	# wget http://dl.fedoraproject.org/pub/epel/7/x86_64/epel-release-7-0.2.noarch.rpm
	# 	# sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-1.noarch.rpm;
	# 	sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm;
	# 	sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm;
	# else
	# 	echo 'Unsupported OS version, skipping addition of EPEL Repository. Exiting...\n\n';
	# 	exit 1;
	# fi

	# clear
	sudo yum -y update;
	sudo yum -y upgrade;
}

## Adding TigerVNC and XRDP to support RDP clients from Windows
## http://ajmatson.net/wordpress/2014/01/install-xrdp-remote-desktop-to-centos-6-5/
## http://www.itzgeek.com/how-tos/linux/centos-how-tos/install-xrdp-on-centos-7-rhel-7.html#axzz3ESHdx6kS

install_xrdp(){
	if [ -z $(yum repolist|grep -i epel) ]; then
		printf 'Installing EPEL Repository...'
		adding_epel_repo;
	fi
	sudo yum -y install xrdp tigervnc-server;
	sudo service vncserver start;
	sudo service xrdp start;
	sudo chkconfig xrdp on;
	sudo chkconfig vncserver on;
	## Allowing incoming TCP connection on 3389 port in firewall
	sudo firewall-cmd --permanent --add-port=3389/tcp
	sudo firewall-cmd --reload
	# sudo iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 3389 -j ACCEPT;
	# sudo service iptables save;
	# sudo service iptables restart;
	# sudo iptables -L;
}

install_hadoop_tools(){
	cd ~/Downloads/
	pwd

	# wget -O - http://psg.mtu.edu/pub/apache/hadoop/common/hadoop-2.5.1/hadoop-2.5.1.tar.gz | tar zxf -
	# wget -O - http://psg.mtu.edu/pub/apache/spark/spark-1.1.0/spark-1.1.0-bin-hadoop2.4.tgz | tar zxf -
	# wget -O - http://www.apache.org/dist/hadoop/common/hadoop-2.5.1/hadoop-2.5.1.tar.gz | tar zxf -
	wget -O - http://www.apache.org/dist/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz | tar zxf -
	# wget -O - http://www.apache.org/dist/spark/spark-1.1.0/spark-1.1.0-bin-hadoop2.4.tgz | tar zxf -
	wget -O - http://www.apache.org/dist/spark/spark-1.2.0/spark-1.2.0-bin-hadoop2.4.tgz | tar zxf -

}

install_misc_tools() {
	sudo yum install -y kernel-devel qt4-devel 
	sudo rpm -Uvh http://download.virtualbox.org/virtualbox/4.3.18/VirtualBox-4.3-4.3.18_96516_el7-1.x86_64.rpm;
	sudo rpm -Uvh https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.5_x86_64.rpm;
}

# Evaluating command line argument
# if [[ $1 =~ [-y] ]]; then
# 	UNATTEND='y';
# fi
if [ -z $1 ]; then
	printf '\nNo options specified, running in manual mode...\n\n';
else
	case $1 in
		'-y' ) UNATTEND='y';;
		* ) print_help;;
	esac;
fi

### 1. Adding EPEL Repo
if [[ $UNATTEND != 'y' ]]; then
	read -t30 -n1 -p 'Add EPEL Repository? Will exit in 30 seconds if no response (y/n): ' ANSWER;
	printf '\n';
else
	ANSWER='y';
fi

if [[ $ANSWER =~ [Yy]$ ]]; then 
	adding_epel_repo;
	ANSWER='';
#	exit 0;
else
	printf '\nSkipping...\n\n';
fi

### 2. Installing Java7
if [[ $UNATTEND != 'y' ]]; then
	read -t30 -n1 -p 'Install Oracle Java SDK 1.7? Will exit in 30 seconds if no response (y/n): ' ANSWER;
	printf '\n';
else
	ANSWER='y';
fi

if [[ $ANSWER =~ [Yy]$ ]]; then 
	install_java7;
	ANSWER='';
#	exit 0;
else
	printf '\nSkipping...\n\n';
fi

### 3. Installing Java8
if [[ $UNATTEND != 'y' ]]; then
	read -t30 -n1 -p 'Install Oracle Java SDK 1.8? Will exit in 30 seconds if no response (y/n): ' ANSWER;
	printf '\n';
else
	ANSWER='y';
fi

if [[ $ANSWER =~ [Yy]$ ]]; then 
	install_java8;
	ANSWER='';
#	exit 0;
else
	printf '\nSkipping...\n\n';
fi

### 4. Installing latest Git
if [[ $UNATTEND != 'y' ]]; then
	read -t30 -n1 -p 'Install latest Git? Will exit in 30 seconds if no response (y/n): ' ANSWER;
	printf '\n';
else
	ANSWER='y';
fi

if [[ $ANSWER =~ [Yy]$ ]]; then 
	install_git;
	ANSWER='';
#	exit 0;
else
	printf '\nSkipping...\n\n';
fi

### 5. Installing Gradle & Maven
if [[ $UNATTEND != 'y' ]]; then
	read -t30 -n1 -p 'Install build tools (Gradle, maven)? Will exit in 30 seconds if no response (y/n): ' ANSWER;
	printf '\n';
else
	ANSWER='y';
fi

if [[ $ANSWER =~ [Yy]$ ]]; then 
	install_gradle;
	install_maven;
	ANSWER='';
#	exit 0;
else
	printf '\nSkipping...\n\n';
fi

### 6. Installing Sublime & IDEA
if [[ $UNATTEND != 'y' ]]; then
	read -t30 -n1 -p 'Install IDEs (Sublime Text, IDEA)? Will exit in 30 seconds if no response (y/n): ' ANSWER;
	printf '\n';
else
	ANSWER='y';
fi

if [[ $ANSWER =~ [Yy]$ ]]; then 
	install_sublime;
	install_idea;
	ANSWER='';
#	exit 0;
else
	printf '\nSkipping...\n\n';
fi

### 7. Installing TigerVMC & RDP
if [[ $UNATTEND != 'y' ]]; then
	read -t30 -n1 -p 'Install TigerVNC & XRDP? Will exit in 30 seconds if no response (y/n): ' ANSWER;
	printf '\n';
else
	ANSWER='y';
fi

if [[ $ANSWER =~ [Yy]$ ]]; then 
	install_xrdp;
	ANSWER='';
#	exit 0;
else
	printf '\nSkipping...\n\n';
fi


exit 0;

install_java7
install_java8
install_maven
install_gradle
install_idea
install_sublime
