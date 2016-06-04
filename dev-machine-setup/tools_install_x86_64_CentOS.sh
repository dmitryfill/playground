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
	cd ~/Downloads
	pwd
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.rpm";
	
	sudo rpm -Uvh jdk-7u75-linux-x64.rpm;

	### http://www.if-not-true-then-false.com/2010/install-sun-oracle-java-jdk-jre-7-on-fedora-centos-red-hat-rhel/
	sudo alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_75/bin/java 200000;

	alternatives_java_latest_install;
}

install_java8(){
	# JDK 8
	cd ~/Downloads
	pwd
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31-linux-x64.rpm";

	sudo rpm -Uvh jdk-8u31-linux-x64.rpm;

	sudo alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_31/bin/java 200000;

	alternatives_java_latest_install;
}

alternatives_java_latest_install(){
	
	sudo alternatives --remove /usr/bin/java java /usr/java/latest/bin/java 200000;
	sudo alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000;
	
	latestid=$(echo -e '\n'| sudo alternatives --config java |grep '/usr/java/latest/'| sed 's/^[+* \t]*//'|awk '{print $1}');
	
	if [ -z $latestid ]; then 
		printf 'Installing /usr/java/latest/...\n'; 
		break;
		### http://wiki.centos.org/HowTos/JavaRuntimeEnvironment
		sudo alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000;
	fi

	latestid=$(echo -e '\n'| sudo alternatives --config java |grep '/usr/java/latest/'| sed 's/^[+* \t]*//'|awk '{print $1}');
	
	echo -e '\n\n'| sudo alternatives --config java;

	printf 'Setting default java to latest... ($latestid)';
	echo -e "$latestid\n\n"| sudo alternatives --config java; 
	# maxid=$(echo -e '\n'| sudo alternatives --config java |grep 'There are '| awk '{print $3}');
	printf '\n\n';
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
	cd ~/opt/
	pwd
	# wget https://www.apache.org/dyn/closer.cgi?path=/kafka/0.8.1/kafka_2.10-0.8.1.tgz
	# wget ftp://apache.mirrors.tds.net/pub/apache.org/kafka/0.8.1/kafka_2.9.2-0.8.1.tgz
	wget -O - http://archive.apache.org/dist/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz | tar xvzf -

	# http://www.slideshare.net/miguno/apache-kafka-08-basic-training-verisign
	# See page 66 for JVM tunning
	# Silver bullet is new G1 “garbage-first” garbage collector
	# Available since JDK7u4. 
	# Substantial improvement over all previous GC’s, at least for Kafka.
	# $ java -Xms4g -Xmx4g -XX:PermSize=48m -XX:MaxPermSize=48m -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35
	# Key candidates for tuning: page 67 
	# num.io.threads should be >= #disks (start testing with == #disks) 
	# num.network.threads adjust it based on (concurrent) #producers, #consumers, and replication factor

	# OS tunning - http://www.michael-noll.com/blog/2013/03/13/running-a-multi-broker-apache-kafka-cluster-on-a-single-node/
	# increase open file handles
	# /etc/security/limits.conf
	# kafka    -    nofile    98304

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
	# wget -O splunk-6.1.0-206881-Linux-x86_64.tgz 'http://www.splunk.com/page/download_track?file=6.1.0/splunk/linux/splunk-6.1.0-206881-Linux-x86_64.tgz&ac=&wget=true&name=wget&platform=Linux&architecture=x86_64&version=6.1.0&product=splunk&typed=release'
	wget -O - 'http://www.splunk.com/page/download_track?file=6.2.0/splunk/linux/splunk-6.2.0-237341-Linux-x86_64.tgz&platform=Linux&architecture=x86_64&version=6.2.0&product=splunk&typed=release&name=linux_installer&d=pro' | tar zxf -

	# rpm -ihv 'http://www.splunk.com/page/download_track?file=6.2.0/splunk/linux/splunk-6.2.0-237341-linux-2.6-x86_64.rpm&platform=Linux&architecture=x86_64&version=6.2.0&product=splunk&typed=release&name=linux_installer&d=pro'
	#tar xvzf splunk-6.0.2-196940-Linux-x86_64.tgz
	# tar xzf splunk-6.1.0-206881-Linux-x86_64.tgz

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

	## TBD Get Splunk Forwarder into the Docker
	## http://www.splunk.com/download/universalforwarder
}

install_haproxy(){
	# Installing HAProxy from source on Cent OS, example was used from here:
	# http://myvirtualife.net/2013/08/19/how-to-build-a-load-balancer-with-haproxy/
	clear
	cd ~/Downloads
	pwd 
	sudo yum -y install wget openssl-devel pcre-devel make gcc curl-devel net-tools
	sudo yum remove haproxy 
	# wget http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev25.tar.gz
	# wget -O - http://www.haproxy.org/download/1.5/src/haproxy-1.5.8.tar.gz | tar zxf -
	# wget -O - http://www.haproxy.org/download/1.5/src/haproxy-1.5.11.tar.gz | tar zxf -
	wget -O - http://www.haproxy.org/download/1.5/src/haproxy-1.5.14.tar.gz | tar zxf -

	# cd haproxy-1.5.8
	# cd haproxy-1.5.11
	cd haproxy-1.5.14
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
	# /usr/lib/systemd/system/haproxy.service

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

	CA_SUBJECT='/C=US/ST=California/L=Los Angeles/O=A-Zona Inc/OU=IT/CN=*.a-zona.com'
	SERVER_SUBJECT='/C=US/ST=California/L=Los Angeles/O=A-Zona Inc/OU=IT/CN=*.a-zona.com'
	CLIENT_SUBJECT='/C=US/ST=California/L=Los Angeles/O=A-Zona Inc/OU=IT/CN=user@a-zona.com'

	# certificate authority creation
	openssl genrsa -out ca.key 4096
	openssl req -new -x509 -days 365 -key ca.key -out ca.crt -subj "$CA_SUBJECT"

	# server certificate in one line
	# based on the wisard - https://www.digicert.com/easy-csr/openssl.htm
	# openssl req -new -newkey rsa:4096 -nodes -out star_a-zona_com.csr -keyout star_a-zona_com.key -subj "/C=US/ST=California/L=Los Angeles/O=A-Zona Inc/OU=IT/CN=*.a-zona.com"

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

install_haproxy_cos7(){
	# based on instructions - http://www.certdepot.net/rhel7-configure-high-available-load-balancer/
	sudo yum -y remove haproxy 
	sudo yum -y install net-tools wget curl-devel keepalived openssl-devel
	
	sudo systemctl enable haproxy
	sudo systemctl enable keepalived

	sudo cp -bv /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak."$(date +%F.%H%m%S)"
	sudo cp -bv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak."$(date +%F.%H%m%S)"

	cd /opt/
	# wget -O - http://www.haproxy.org/download/1.5/src/haproxy-1.5.8.tar.gz | tar zxf -
	# wget -O - http://www.haproxy.org/download/1.5/src/haproxy-1.5.11.tar.gz | tar zxf -
	wget -O - http://www.haproxy.org/download/1.5/src/haproxy-1.5.14.tar.gz | tar zxf -

	# cd haproxy-1.5.8
	# cd haproxy-1.5.11
	cd haproxy-1.5.14
	make TARGET=linux2628 CPU=x86_64 USE_OPENSSL=1 USE_ZLIB=1 USE_PCRE=1
	sudo make install
	sudo cp -bv haproxy* /usr/sbin/

	#sudo cp examples/examples.cfg /etc/haproxy/haproxy.cfg
	sudo mkdir /var/lib/haproxy
	sudo touch /var/lib/haproxy/stats
	# sudo useradd -r haproxy
	sudo mkdir /etc/haproxy/errors
	cp -Rv examples/errorfiles/* /etc/haproxy/errors/

sudo cat << EOF >> /usr/lib/systemd/system/haproxy.service
[Unit]
Description=HAProxy Load Balancer
After=syslog.target network.target

[Service]
User=haproxy
Group=haproxy
ExecStart=/usr/sbin/haproxy-systemd-wrapper -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid
ExecReload=/bin/kill -USR2 $MAINPID

[Install]
WantedBy=multi-user.target
EOF

sudo cat << EOF >> /etc/keepalived/keepalived.conf
vrrp_script chk_haproxy {
  script "killall -0 haproxy" # check the haproxy process
  interval 2 # every 2 seconds
  weight 2 # add 2 points if OK
}

vrrp_instance VI_1 {
  interface eth0 # interface to monitor
  state MASTER # MASTER on haproxy1, BACKUP on haproxy2
  virtual_router_id 51
  priority 101 # 101 on haproxy1, 100 on haproxy2
  virtual_ipaddress {
    10.0.0.15 # virtual ip address 
  }
  track_script {
    chk_haproxy
  }
}
EOF

	echo 'net.ipv4.ip_nonlocal_bind=1' >> /etc/sysctl.conf

	sysctl -p

	# FirewallD could be disabled completely instead of adding all possible ports
	sudo systemctl disable firewalld.service
	sudo systemctl stop firewalld.service

	sudo systemctl enable haproxy
	sudo systemctl enable keepalived

	sudo systemctl start keepalived
	sudo systemctl start haproxy

# systemctl status haproxy
# haproxy.service - HAProxy Load Balancer
#    Loaded: loaded (/usr/lib/systemd/system/haproxy.service; enabled)
#    Active: inactive (dead)

# [root@vm-cos7-hapxy01 ~]# cat /usr/lib/systemd/system/haproxy.service
# [Unit]
# Description=HAProxy Load Balancer
# After=syslog.target network.target

# [Service]
# User=haproxy
# Group=haproxy
# ExecStart=/usr/sbin/haproxy-systemd-wrapper -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid
# ExecReload=/bin/kill -USR2 $MAINPID

# [Install]
# WantedBy=multi-user.target

}

install_teamcity(){
	# modified version of original instructions from here:
	# http://latobcode.wordpress.com/2013/11/26/teamcity-8-on-centos-6-4-from-scratch/
	sudo yum install epel-release -y
	sudo yum group install "Development Tools" -y
	sudo yum install -y java net-tools python-devel php-devel nodejs-devel npm ruby-devel thrift-devel nodejs-devel npm 
	# wget http://download.jetbrains.com/teamcity/TeamCity-8.1.2.tar.gz
	wget -O - http://download.jetbrains.com/teamcity/TeamCity-8.1.5.tar.gz | tar zxf -
	# tar xzf TeamCity-8.1.2.tar.gz
	# mv /opt/TeamCity /opt/TeamCity.bak2
	sudo mv -v TeamCity /opt/
	sudo useradd teamcity
	chown -R teamcity:teamcity /opt/TeamCity
	# sudo touch /etc/init.d/teamcity

sudo cat << EOF >> /usr/lib/systemd/system/teamcity.service
[Unit]
Description=Team City Build Server
After=network.target

[Service]
Type=forking
User=teamcity
Group=teamcity
WorkingDirectory=/opt/TeamCity/bin/

ExecStart=/opt/TeamCity/bin/runAll.sh start
ExecStop=/opt/TeamCity/bin/runAll.sh stop

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

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
	sudo systemctl disable firewalld.service

	## Dynamic memory - http://technet.microsoft.com/en-us/library/dn531026.aspx
	sudo echo 'SUBSYSTEM=="memory", ACTION=="add", ATTR{state}="online"' >/etc/udev/rules.d/100-balloon.rules
	cat /etc/udev/rules.d/100-balloon.rules

	sudo reboot

}

install_cassandra(){
	# http://planetcassandra.org/blog/installing-the-cassandra-spark-oss-stack/
	cd /opt/
	pwd
	sudo yum install epel-release -y
	# sudo yum group install "Development Tools" -y
	sudo yum install -y wget nano java net-tools python-devel thrift-devel jna

	install_java7

	# wget -O - http://www.apache.org/dist/cassandra/2.1.1/apache-cassandra-2.1.1-bin.tar.gz | tar zxf -
	# wget -O - http://www.apache.org/dist/cassandra/2.1.2/apache-cassandra-2.1.2-bin.tar.gz | tar zxf -
	wget -O - http://archive.apache.org/dist/cassandra/2.2.0/apache-cassandra-2.2.0-bin.tar.gz | tar zxf -

	sudo ln -snf /opt/apache-cassandra-2.2.0/ /opt/cassandra

	sudo mkdir -p /srv/cassandra/{log,data,commitlogs,saved_caches}
	(grep -q '^cassandra:' /etc/passwd) || useradd -c "Apache Cassandra" -s /bin/bash -d /srv/cassandra cassandra
	sudo chown -R cassandra:cassandra /srv/cassandra

ip=$(ip addr show eth0 |perl -ne 'if ($_ =~ /inet (\d+\.\d+\.\d+\.\d+)/) { print $1 }') 
perl -i.bak -pe "
  s/^(cluster_name:).*/\$1 'css.cave.a-zona.com'/;
  s/^(listen|rpc)_address:.*/\${1}_address: $ip/;
  s|/var/lib|/srv|;
  s/(\s+-\s+seeds:).*/\$1 '10.0.0.40,10.0.0.41'/
" /opt/cassandra/conf/cassandra.yaml
# EOF

cat /opt/cassandra/conf/cassandra.yaml |grep -i 'cluster_name\|seed\|listen_\|snitch\|port:\|srv\|saved_caches'

cat > /opt/cassandra/conf/log4j-server.properties <<EOF
log4j.rootLogger=WARN,R
log4j.appender.R=org.apache.log4j.RollingFileAppender
log4j.appender.R.maxFileSize=20MB
log4j.appender.R.maxBackupIndex=20
log4j.appender.R.layout=org.apache.log4j.PatternLayout
log4j.appender.R.layout.ConversionPattern=%5p [%t] %d{ISO8601} %F (line %L) %m%n
log4j.appender.R.File=/srv/cassandra/log/system.log
log4j.logger.org.apache.thrift.server.TNonblockingServer=ERROR
EOF

# sudo cat << EOF >> /usr/lib/systemd/system/cassandra.service
sudo cat > /usr/lib/systemd/system/cassandra.service <<EOF
[Unit]
Description=Cassandra Tarball
After=network.target
 
[Service]
User=cassandra
Group=cassandra
RuntimeDirectory=cassandra
PIDFile=/run/cassandra/cassandra.pid
ExecStart=/opt/cassandra/bin/cassandra -f -p /run/cassandra/cassandra.pid
StandardOutput=journal
StandardError=journal
OOMScoreAdjust=-500
LimitNOFILE=infinity
LimitMEMLOCK=infinity
LimitNPROC=infinity
LimitAS=infinity
Environment=MAX_HEAP_SIZE=8G HEAP_NEWSIZE=1G CASSANDRA_HEAPDUMP_DIR=/srv/cassandra/log
CPUAccounting=true
CPUShares=1000
 
[Install]
WantedBy=multi-user.target
EOF

	sudo systemctl enable cassandra
	sudo systemctl start cassandra
	sudo systemctl status cassandra

	sudo firewall-cmd --permanent --add-port=9042/tcp
	sudo firewall-cmd --permanent --add-port=9160/tcp
	sudo firewall-cmd --permanent --add-port=7000/tcp
	sudo firewall-cmd --permanent --add-port=7001/tcp
	sudo firewall-cmd --permanent --add-port=7199/tcp
	sudo firewall-cmd --permanent --add-port=7190/tcp

	sudo firewall-cmd --reload

	sudo firewall-cmd --list-all

	# As an option firewall could be disabled completely
	sudo systemctl disable firewalld.service
	sudo systemctl stop firewalld.service
}

install_cassandra_datastax(){
cat > /etc/yum.repos.d/datastax.repo <<EOF
[datastax] 
name = DataStax Repo for Apache Cassandra
baseurl = http://rpm.datastax.com/community
enabled = 1
gpgcheck = 0
EOF

	sudo yum update -y
	sudo yum install -y dsc22
	sudo yum install -y cassandra21-tools
	sudo yum install -y datastax-agent

	cat /etc/cassandra/conf/cassandra.yaml |grep -i 'cluster_name\|seed\|listen_\|snitch\|port:\|srv\|saved_caches'|grep -i '^[^#\;]'

ip=$(ip addr show eth0 |perl -ne 'if ($_ =~ /inet (\d+\.\d+\.\d+\.\d+)/) { print $1 }') 
perl -i.bak -pe "
  s/^(cluster_name:).*/\$1 'css.cave.a-zona.com'/;
  s/^(listen|rpc)_address:.*/\${1}_address: $ip/;
  s/(\s+-\s+seeds:).*/\$1 '10.0.0.40,10.0.0.41,10.0.0.42,10.0.0.43'/;
  s/^(endpoint_snitch:).*/\$1 GossipingPropertyFileSnitch/
" /etc/cassandra/conf/cassandra.yaml

perl -i.bak -pe "
  s/^(dc=)*/\$1dc1-hv01/;
  s/^(rack=)*/\$1rack1/
" /etc/cassandra/conf/cassandra-rackdc.properties


	echo "stomp_interface: 10.0.0.50" | sudo tee -a /var/lib/datastax-agent/conf/address.yaml
	# If SSL communication is enabled in opscenterd.conf, use SSL in address.yaml.
	# echo "use_ssl: 1" | sudo tee -a /var/lib/datastax-agent/conf/address.yaml

	sudo systemctl enable cassandra
	sudo systemctl start cassandra
	sudo systemctl status cassandra

	sudo systemctl enable datastax-agent
	sudo systemctl start datastax-agent
	sudo systemctl status datastax-agent
	# sudo service datastax-agent start

	sudo firewall-cmd --permanent --add-port=9042/tcp
	sudo firewall-cmd --permanent --add-port=9160/tcp
	sudo firewall-cmd --permanent --add-port=7000/tcp
	sudo firewall-cmd --permanent --add-port=7001/tcp
	sudo firewall-cmd --permanent --add-port=7199/tcp
	sudo firewall-cmd --permanent --add-port=7190/tcp

	sudo firewall-cmd --reload

	sudo firewall-cmd --list-all

	# As an option firewall could be disabled completely
	sudo systemctl disable firewalld.service
	sudo systemctl stop firewalld.service

}

install_ambari(){
	# Prereqs
	sudo yum install -y epel-release wget curl git svn nano docker ntp ntpdate ntp-doc system-storage-manager net-tools java-1.7.0-openjdk-devel.x86_64
	sudo yum install -y java-1.8.0-openjdk-devel.x86_64

	sudo systemctl disable firewalld.service
   	sudo systemctl stop firewalld.service
   	sudo systemctl status firewalld.service

	sudo systemctl status docker
	sudo systemctl enable docker
	sudo systemctl start docker

	sudo systemctl status ntpd
	sudo systemctl enable ntpd
	sudo systemctl start ntpd
	sudo systemctl status ntpd

	# Set global ll='ls -lahGF --color'
	sed -i 's/ls -l --color/ls -lahGF --color/g' /etc/profile.d/colorls.sh

	# https://cwiki.apache.org/confluence/display/AMBARI/Install+Ambari+2.1.0+from+Public+Repositories
	cd /etc/yum.repos.d/
	
	# (Redhat / CentOS / Oracle) 6
	# http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.1.0/ambari.repo
	# http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.1.1/ambari.repo

	# (Redhat / CentOS / Oracle) 7
	# wget http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.1.0/ambari.repo
	sudo wget -O /etc/yum.repos.d/ambari.repo http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.1.1/ambari.repo

	sudo yum install ambari-server

	sudo ambari-server setup

	sudo ambari-server start 
}

install_mesos_aurora(){
	# Prereqs ...
	# Adding EPEL
	# sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm;
	sudo yum -y install epel-release
	sudo yum groupinstall -y "Development Tools"
	sudo yum install -y wget curl-devel perl-devel perl-ExtUtils-Embed python-devel java-1.7.0-openjdk-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 apr-devel sqlite-devel db4-devel subversion-devel docker
	sudo systemctl enable docker.service
	sudo systemctl start docker.service

	# CentOS7 specific - it seems to need older verison of cyrus-sassl
	# cd /usr/lib64/;ln -snf libsasl2.so.3.0.0 libsasl2.so.2;ls -lahGF /usr/lib64/ |grep libsasl;  

	# Build and Install svn 1.8+
	cd /opt/
	pwd
	wget -O - http://www.dsgnwrld.com/am/subversion/subversion-1.8.10.tar.gz | tar xzf -
	cd subversion-1.8.10/
	./configure
	make
	sudo make install

	cd /opt/
	pwd	
	# Install maven
	wget -O - http://psg.mtu.edu/pub/apache/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz | tar zxf -
	sudo ln -snf /opt/apache-maven-3.2.3/bin/mvn /usr/bin/mvn

	# Install Mesos & Aurora
	wget -O - http://www.apache.org/dist/mesos/0.20.1/mesos-0.20.1.tar.gz | tar zxf -
	# http://psg.mtu.edu/pub/apache/mesos/0.20.1/mesos-0.20.1.tar.gz
	# wget -O - http://psg.mtu.edu/pub/apache/incubator/aurora/0.5.0/apache-aurora-0.5.0-incubating.tar.gz | tar zxf -
	wget -O - http://www.apache.org/dist/incubator/aurora/0.5.0/apache-aurora-0.5.0-incubating.tar.gz | tar zxf -
	
	cd /opt/mesos-0.20.1/
	mkdir build
	cd build/
	../configure
	make
	make check
	sudo make install 

	sudo firewall-cmd --permanent --add-port=2181/tcp
	sudo firewall-cmd --permanent --add-port=5050/tcp
	sudo firewall-cmd --permanent --add-port=5051/tcp

	# As an option firewall could be disabled completely
	sudo systemctl disable firewalld.service
	sudo systemctl stop firewalld.service

	# nano /usr/lib/systemd/system/mesos-master.service
 
sudo cat << EOF >> /usr/lib/systemd/system/mesos-master.service
[Unit]
Description=Mesos Master
After=network.target

[Service]
Type=forking
WorkingDirectory=/opt/mesos-0.20.1/build/

ExecStart=/opt/mesos-0.20.1/build/bin/mesos-master.sh --ip=0.0.0.0 --work_dir=/var/lib/mesos --cluster=devel --zk=zk://127.0.0.1:2181/mesos --quorum=1

Restart=on-failure

[Install]
WantedBy=multi-user.target

EOF

sudo cat << EOF >> /usr/lib/systemd/system/mesos-slave.service
[Unit]
Description=Mesos Master
After=network.target

[Service]
Type=forking
WorkingDirectory=/opt/mesos-0.20.1/build/

ExecStart=/opt/mesos-0.20.1/build/bin/mesos-slave.sh --master=zk://127.0.0.1:2181/mesos

Restart=on-failure

[Install]
WantedBy=multi-user.target

EOF

}

install_mesos_maraphon(){

	## http://mesosphere.com/downloads/
	sudo rpm -Uvh http://downloads.mesosphere.io/master/centos/7/mesos-0.20.1-1.0.centos701406.x86_64.rpm;
	sudo systemctl enable mesos-master.service
	sudo systemctl enable mesos-slave.service
	sudo systemctl daemon-reload

	# Set Cluster name, more consif options:
	# http://mesosphere.com/docs/reference/mesos-master/
	# http://mesosphere.com/docs/reference/mesos-slave/
	echo 'dev0' > /etc/mesos-master/cluster
	
	# CentOS7 specific - it seems to need older verison of cyrus-sassl
	# cd /usr/lib64/;ln -snf libsasl2.so.3.0.0 libsasl2.so.2;ls -lahGF /usr/lib64/ |grep libsasl;

	# Point to Zookeeper
	echo 'zk://127.0.0.1:2181,127.0.0.1:2181,127.0.0.1:2181/mesos' > /etc/mesos/zk

	# Enable dockers support
	# http://mesosphere.com/docs/tutorials/launch-docker-container-on-mesosphere/
	sudo yum install -y wget curl-devel python-devel java-1.7.0-openjdk-devel zlib-devel docker net-tools cyrus-sasl-devel
	sudo systemctl enable docker.service
	sudo systemctl daemon-reload

	sudo systemctl start docker.service

	echo 'docker,mesos' > /etc/mesos-slave/containerizers
	echo '5mins' > /etc/mesos-slave/executor_registration_timeout


	sudo firewall-cmd --permanent --add-port=5050/tcp
	sudo firewall-cmd --permanent --add-port=5051/tcp
	sudo firewall-cmd --reload

	sudo firewall-cmd --list-all

	sudo systemctl start mesos-master.service
	sudo systemctl start mesos-slave.service

	sudo systemctl status mesos-slave
	sudo systemctl status mesos-slave

	# Test 
	# mesos-execute --master="$(mesos-resolve `cat /etc/mesos/zk`)" --name="cluster-test" --command="printf date +%F_%H%M%s; sleep 55"

	cd /opt/
	pwd
	wget -O - http://downloads.mesosphere.io/marathon/v0.7.0/marathon-0.7.0.tgz | tar zxf -;

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

