#!/bin/bash
clear
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

# Get latest updates
os_updates(){
	clear;
	sudo yum -y update;
	sudo yum -y upgrade;
}

# 0. Get Oracle Java JDK
# http://forums.linuxmint.com/viewtopic.php?f=197&t=149068
install_java6(){
	# JDK 6
	cd ~/Downloads
	pwd
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin"
	# chmod +x jdk-6u45-linux-x64.bin
	# ./jdk-6u45-linux-x64.bin
	# sudo mv jdk1.6.0_45 /usr/lib/jvm/

	# update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.6.0_45/bin/java 1065
	# update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.6.0_45/bin/javac 1065
	# update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk1.6.0_45/bin/jar 1065
	# update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm/jdk1.6.0_45/bin/javaws 1065
	# update-alternatives --install /usr/bin/javadoc javadoc /usr/lib/jvm/jdk1.6.0_45/bin/javadoc 1065
	# update-alternatives --config java
}

install_java7(){
	# JDK 7
	cd ~/Downloads
	pwd
	# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.tar.gz"
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.tar.gz"
	# tar xvzf jdk-7u45-linux-x64.tar.gz
	tar xvzf jdk-7u51-linux-x64.tar.gz
	# rm jdk-7u45-linux-x64.tar.gz
	rm jdk-7u51-linux-x64.tar.gz

	# if [ ! -d '/usr/lib/jvm' ]; then mkdir /usr/lib/jvm; fi && mv /tmp/jdk1.7.0_45 /usr/lib/jvm

	# sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.7.0_45/bin/java 1065
	# sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.7.0_45/bin/javac 1065
	# sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk1.7.0_45/bin/jar 1065
	# sudo update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm/jdk1.7.0_45/bin/javaws 1065
	# sudo update-alternatives --install /usr/bin/javadoc javadoc /usr/lib/jvm/jdk1.7.0_45/bin/javadoc 1065
	# sudo update-alternatives --config java
}

install_java8(){
	# JDK 8
	cd ~/Downloads
	pwd
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8-b132/jdk-8-linux-x64.tar.gz"
}


install_cdh5(){
	clear
	# 1. Get Cloudera CDH 5
	cd ~/Downloads
	pwd
	wget http://archive.cloudera.com/cm5/installer/latest/cloudera-manager-installer.bin
	chmod u+x cloudera-manager-installer.bin

	wget http://archive.cloudera.com/cdh5/one-click-install/redhat/6/x86_64/cloudera-cdh-5-0.x86_64.rpm
	sudo yum --nogpgcheck localinstall cloudera-cdh-5-0.x86_64.rpm

	## Disable SELinux
	# sudo setenforce 0
	# nano /etc/selinux/config

	# sudo ./cloudera-manager-installer.bin

	sudo sysctl -a |grep swapp
	# vm.swappiness = 60
	sudo sysctl -w vm.swappiness=0
	# vm.swappiness = 0
	sudo sysctl -a |grep swapp

	# Disabling swappiness per cloudera recommendation
	# vm.swappiness =	0

	# Disable ipv4 firewall	
}


install_kafka(){
	clear
	# 2. Get Kafka
	cd ~/Downloads
	pwd
	# wget https://www.apache.org/dyn/closer.cgi?path=/kafka/0.8.1/kafka_2.10-0.8.1.tgz
	wget ftp://apache.mirrors.tds.net/pub/apache.org/kafka/0.8.1/kafka_2.9.2-0.8.1.tgz
	tar xvzf kafka_2.9.2-0.8.1.tgz
	sudo mv -f ~/Downloads/kafka_2.9.2-0.8.1/ /opt/

	#bash /opt/kafka_2.9.2-0.8.1/bin/kafka-server-start.sh /opt/kafka_2.9.2-0.8.1/config/server-0.properties
	#bash /opt/kafka_2.9.2-0.8.1/bin/kafka-server-start.sh /opt/kafka_2.9.2-0.8.1/config/server-1.properties
	#bash /opt/kafka_2.9.2-0.8.1/bin/kafka-server-start.sh /opt/kafka_2.9.2-0.8.1/config/server-2.properties	
}

install_splunk(){
	clear
	# 2. Get Splunk
	cd ~/Downloads
	pwd
	rm -Rf ~/Downloads/splunk
	# wget -O splunk-6.0.2-196940-Linux-x86_64.tgz 'http://www.splunk.com/page/download_track?file=6.0.2/splunk/linux/splunk-6.0.2-196940-Linux-x86_64.tgz&ac=&wget=true&name=wget&platform=Linux&architecture=x86_64&version=6.0.2&product=splunk&typed=release'
	wget -O splunk-6.1.0-206881-Linux-x86_64.tgz 'http://www.splunk.com/page/download_track?file=6.1.0/splunk/linux/splunk-6.1.0-206881-Linux-x86_64.tgz&ac=&wget=true&name=wget&platform=Linux&architecture=x86_64&version=6.1.0&product=splunk&typed=release'
	#tar xvzf splunk-6.0.2-196940-Linux-x86_64.tgz
	tar xzf splunk-6.1.0-206881-Linux-x86_64.tgz

	sudo service splunk stop
	sudo /opt/splunk/bin/splunk stop

	sudo mv -f /opt/splunk /opt/splunk.bak
	sudo mv -f splunk /opt/

	# http://docs.splunk.com/Documentation/Splunk/latest/Installation/InstallonLinux
	if id -u splunksvc >/dev/null 2>&1; then
		printf '\nUser splunksvc already exist, skipping creation...\n';
	else
		printf '\nCreating user splunksvc...\n';
		sudo useradd splunksvc
	fi

	sudo chown -R splunksvc:splunksvc /opt/splunk
	
	# cd /opt/splunk/bin/
	sudo /opt/splunk/bin/splunk enable boot-start -user splunksvc
	sudo /opt/splunk/bin/splunk start --accept-license --answer-yes
	sudo service splunk start
	sudo service splunk status	

	# Get Splunk SDK java sources 
	mkdir -p ~/git
	cd ~/git
	pwd
	git clone https://github.com/splunk/splunk-sdk-java.git
}

install_haproxy(){
	# Installing HAProxy from source on Cent OS, example was used from here:
	# http://myvirtualife.net/2013/08/19/how-to-build-a-load-balancer-with-haproxy/
	clear
	cd ~/Downloads
	pwd 
	sudo yum -y install wget openssl-devel pcre-devel make gcc
	wget http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev25.tar.gz
	tar xzf haproxy-1.5-dev25.tar.gz
	cd haproxy-1.5-dev25
	make TARGET=linux2628 CPU=x86_64 USE_OPENSSL=1 USE_ZLIB=1 USE_PCRE=1
	sudo make PREFIX=/opt/haproxy-ssl install
	sudo ln -snf /opt/haproxy-ssl/sbin/haproxy /usr/sbin/haproxy
	sudo cp examples/haproxy.init /etc/init.d/haproxy
	sudo chmod 755 /etc/init.d/haproxy
	sudo mkdir /etc/haproxy
	sudo cp examples/examples.cfg /etc/haproxy/haproxy.cfg
	sudo mkdir /var/lib/haproxy
	sudo touch /var/lib/haproxy/stats
	sudo useradd -r haproxy
	sudo mkdir /etc/haproxy/errors
	cp -Rv examples/errorfiles/* /etc/haproxy/errors/

	## http://www.virtualtothecore.com/en/balance-multiple-view-connection-servers-using-haproxy/

	# sudo yum -y install keepalived
	# Before you can load the virtual IP and test it, there are some other configuration changes to be made. First, add this line at the end of the /etc/sysctl.conf file:
	# net.ipv4.ip_nonlocal_bind = 1
	
	# sudo sysctl -p
	
	# Extra configuration of iptables is required for keepalived, in particular we must enable support for multicast broadcast packets:
	# sudo iptables -I INPUT -d 224.0.0.0/8 -j ACCEPT

	# Then, add this rule for the VRRP IP protocol:
	# sudo iptables -I INPUT -p 112 -j ACCEPT
	# In addition insert a rule that will correspond with the traffic that you are load balancing, for View is HTTP and HTTPS (by default is only https, but I’m going to create a rule inside HAProxy to redirect http calls to https):
	# sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
	# sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT

	# Finally save the iptables config so it will be restored after restarting, and start Keepalived:
	# sudo service iptables save
	# sudo service keepalived start

	## Generate OpenSSL certs, original instructions here:
	# https://gist.github.com/tomdz/5339163

	export CA_SUBJECT='/C=US/ST=California/L=Los Angeles/CN=ca@a-zona.com'
	export SERVER_SUBJECT='/C=US/ST=California/L=Los Angeles/CN=sysadmin@a-zona.com'
	export CLIENT_SUBJECT='/C=US/ST=California/L=Los Angeles/CN=user@a-zona.com'

	# certificate authority creation
	openssl genrsa -out ca.key 4096
	openssl req -new -x509 -days 365 -key ca.key -out ca.crt -subj "$CA_SUBJECT"

	# server certificate creation
	openssl genrsa -out server.key 1024
	openssl req -new -key server.key -out server.csr -subj "$SERVER_SUBJECT"
	openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

	# client certificate creation
	openssl genrsa -out client.key 1024
	openssl req -new -key client.key -out client.csr -subj "$CLIENT_SUBJECT"
	openssl x509 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt

	cat server.crt server.key > server.pem
	sudo cp server.pem /etc/haproxy/server.pem
	sudo cp ca.crt /etc/haproxy/ca.crt

	sudo service haproxy check
	sudo service haproxy start
	sudo chkconfig haproxy on

}

install_teamcity(){
	# modified version of original instructions from here:
	# http://latobcode.wordpress.com/2013/11/26/teamcity-8-on-centos-6-4-from-scratch/
	yum install -y java
	# wget http://download.jetbrains.com/teamcity/TeamCity-8.1.2.tar.gz
	wget -O - http://download.jetbrains.com/teamcity/TeamCity-8.1.5.tar.gz | tar zxf -
	# tar xzf TeamCity-8.1.2.tar.gz
	# mv /opt/TeamCity /opt/TeamCity.bak2
	sudo mv -v TeamCity /opt/
	sudo useradd -r teamcity
	chown -R teamcity:teamcity /opt/TeamCity
	# sudo touch /etc/init.d/teamcity

	sudo cat << EOF >> /etc/init.d/teamcity
	#!/bin/bash
	#
	# description: TeamCity startup script
	# /etc/init.d/teamcity
	#
	if id -u teamcity >/dev/null 2>&1; then
		printf '\nUser teamcity already exist, skipping creation...\n';
	else
		printf '\nCreating user teamcity...\n';
		sudo useradd -r teamcity
	fi

	chown -R teamcity:teamcity /opt/TeamCity

	TEAMCITY_USER=teamcity
	TEAMCITY_SERVER=/opt/TeamCity/bin/runAll.sh

	case "$1" in
	start)
	    sudo -u $TEAMCITY_USER -s -- sh -c "$TEAMCITY_SERVER start"
	    ;;
	stop)
	    sudo -u $TEAMCITY_USER -s -- sh -c "$TEAMCITY_SERVER stop"
	    ;;
	*)
	    echo "Usage: $0 {start|stop}"
	    exit 1
	    ;;
	esac

	exit 0
	EOF

	sudo chmod 755 /etc/init.d/teamcity
	sudo service teamcity check
	sudo chkconfig teamcity on
	sudo service teamcity start
	sudo firewall-cmd --zone=public --add-port=8111/tcp
}

install_build(){
	sudo yum install -y git docker docker-registry java;
	sudo rpm -Uvh http://dl.bintray.com/jfrog/artifactory-rpms/artifactory-3.4.1.rpm
	sudo firewall-cmd --zone=public --add-port=8081/tcp
	sudo service artifactory start
	sudo chkconfig artifactory on

}

install_mesos(){
	# Adding EPEL
	sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm;
	# Prereqs
	sudo yum groupinstall -y "Development Tools"
	sudo yum install -y wget curl-devel python-devel java-1.7.0-openjdk-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 apr-devel sqlite-devel db4-devel subversion-devel docker
	sudo service docker start
	sudo chkconfig docker on

	# Build and  Install svn 1.8+
	cd /opt/
	wget -O - http://www.dsgnwrld.com/am/subversion/subversion-1.8.10.tar.gz | tar xzf -
	cd subversion-1.8.10/
	./configure
	make
	sudo make install
	
	# Install maven
	wget -O - http://psg.mtu.edu/pub/apache/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz | tar zxf -
	sudo ln -snf /opt/apache-maven-3.2.3/bin/mvn /usr/bin/mvn

	# Install Mesos
	wget -O - http://www.apache.org/dist/mesos/0.20.1/mesos-0.20.1.tar.gz | tar zxf -

	cd /opt/mesos-0.20.1/
	mkdir build
	cd build/
	../configure
	make
	make check
	sudo make install 

	sudo firewall-cmd --zone=public --add-port=5050/tcp

}

print_help(){
	printf '\n\n'
	printf 'This script is installs different tools, depending on the option you select:\n';
	printf '\n--<arg> Command line parameters\n\tX. Interactive option selection\n'
	printf '\n--all\n\t0. Install All (Java 6 JDK, Java 7 JDK, Java 8 JDK, Cloudera CDH5, Splunk, Kafka) - Default';
	printf '\n--j6\n\t1. Install Java 6 JDK only';
	printf '\n--j7\n\t2. Install Java 7 JDK only';
	printf '\n--j8\n\t3. Install Java 8 JDK only';
	printf '\n--j\n\t4. Install Java 6 JDK, Java 7 JDK & Java 8 JDK';
	printf '\n--cdh5\n\t5. Install Cloudera CDH5 only';
	printf '\n--splunk\n\t6. Install Splunk only';
	printf '\n--kafka\n\t7. Install Kafka only';

	printf '\n\n\t9. Exit'
	printf '\n\n'
}


os_updates

if [[ $* == '' ]]; then
	#statements
	print_help
	read -t30 -n1 -r -p 'Please select your option in next 30 seconds: ' KEY

	printf '\n\n'
	printf 'KEY = %d' $KEY
	printf '\narg[] = %s' $*
	printf '\n\n'

	case $KEY in
		0)
			printf '\nKEY == 0, option --all\n';;
		1)
			printf '\nKEY == 1, option --j6\n';;
		6)
			printf '\nKEY == 6, option --splunk\n'; install_splunk;;
		*)
			printf '\nUnknown option, exit\n\n'; exit;;
	esac
else
	printf '\n\n'
	printf 'KEY = %d' $KEY
	printf '\narg[] = %s' $*
	printf '\n\n'


fi


printf '\n ===========[ END ]========================\n\n'

# read -t30 -n1 -r -p "Press any key in the next 30 seconds..." KEY

