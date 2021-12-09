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