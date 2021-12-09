#!/bin/bash

#Uitschakelen Selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config


#Installeren dnf
dnf install wget -y


#Splunk configuratie
groupadd splunk
useradd -d /opt/splunk -m -g splunk splunk