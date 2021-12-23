#!/bin/bash

#Uitschakelen Selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config


#Installeren dnf
dnf install wget -y


#Splunk configuratie
groupadd splunk
useradd -d /opt/splunk -m -g splunk splunk
id
getconf LONG_BIT

#Downloaden splunk - versie 8.1.0
wget https://download.splunk.com/products/splunk/releases/8.1.0/linux/splunk-8.1.0-f57c09e87251-Linux-x86_64.tgz

#Uitpakken splunk
tar xvzf splunk-8.1.0-f57c09e87251-Linux-x86_64.tgz -C /opt


#Splunk configuratie Firewall
firewall-cmd --zone=public --permanent --add-port 8080/tcp
firewall-cmd --zone=public --permanent --add-port 8000/tcp
firewall-cmd --zone=public --permanent --add-port 5514/udp
firewall-cmd --zone=public --permanent --add-port 9997/udp
firewall-cmd --zone=public --permanent --add-port 9997/tcp
firewall-cmd --reload


cd /
cd opt/splunk/bin
chown -R splunk: /opt/splunk/
cd /
cd opt/splunk/bin

./splunk start --accept-license --answer-yes --no-prompt --seed-passwd Cisco06!

./splunk enable boot-start
./splunk enable listen 9997
./splunk restart
