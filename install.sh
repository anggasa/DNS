#!/bin/bash
#
# Script Copyright Angga Shaputra
# ==========================
# 

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
#MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0'`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
#ether=`ifconfig | cut -c 1-8 | sort | uniq -u | grep venet0 | grep -v venet0:`
#if [ "$ether" = "" ]; then
#        ether=eth0
#fi

#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
#if [ "$MYIP" = "" ]; then
#		MYIP=$(wget -qO- ipv4.icanhazip.com)
#fi
#MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/anggasa/worm/master/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
wget "http://www.webmin.com/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

# update
apt-get update; apt-get -y upgrade;

# install essential package
echo "mrtg mrtg/conf_mods boolean true" | debconf-set-selections
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# update apt-file
apt-file update

# install screenfetch
cd
wget 'https://raw.githubusercontent.com/anggasa/worm/master/screenfetch-dev'
mv screenfetch-dev /usr/bin/screenfetch-dev
chmod +x /usr/bin/screenfetch-dev
echo "clear" >> .profile
echo "screenfetch-dev" >> .profile
cd

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart

# install webmin
cd
wget -O webmin-current.deb "http://www.webmin.com/download/deb/webmin-current.deb"
dpkg -i --force-all webmin-current.deb;
apt-get -y -f install;
rm /root/webmin-current.deb
service webmin restart
cd
# finishing
chown -R www-data:www-data /home/vps/public_html
service ssh restart
service fail2ban restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo "============================================================="  | tee -a log-install.txt
echo "Info SERVER" | tee log-install.txt
echo "IP Server            : $MYIP"  | tee -a log-install.txt
echo "Control Panel Port   : $MYIP:10000"  | tee -a log-install.txt
echo "Timezone             : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "Fail2Ban             : [Enable]"  | tee -a log-install.txt
echo "IPv6                 : [Disable]"  | tee -a log-install.txt
echo "============================================================="  | tee -a log-install.txt
echo "Silahkan Reboot Server Anda"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Terimakasih :D"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Angga Shaputra"  | tee -a log-install.txt
cd
rm -f /root/debian7.sh
