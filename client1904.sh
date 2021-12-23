#!/bin/bash
# Fix repositorys
sed -i 's#nl.archive.ubuntu.com#old-releases.ubuntu.com#' /etc/apt/sources.list
sed -i 's#security.ubuntu.com#old-releases.ubuntu.com#' /etc/apt/sources.list

# Update system
apt update -y && apt upgrade -y
apt -y install firefox thunderbird p7zip libreoffice sssd-ad sssd-tools realmd adcli ntp nfs-common hxtools libpam-mount

# Set DNS, IP, Proxy, NTP
# IP and DNS is set by DHCP.
sed -i 's/pool/#pool/' /etc/ntp.conf
echo 'server 10.100.0.10' >> /etc/ntp.conf

echo 'http_proxy="http://10.100.0.7:3128/"' >> /etc/environment
echo 'https_proxy="http://10.100.0.7:3128/"' >> /etc/environment
echo 'no_proxy="localhost,127.0.0.1,::1"'
touch /etc/apt/apt.conf.d/proxy.conf
echo 'Acquire::http::Proxy "http://10.100.0.7:3128/";' >> /etc/apt/apt.conf.d/proxy.conf
echo 'Acquire::https::Proxy "http://10.100.0.7:3128/";' >> /etc/apt/apt.conf.d/proxy.conf

# Join domain
echo 'cisco06' | realm join -U waltervl treecko.ijselu.local

# Enable home dir creation
pam-auth-update --enable mkhomedir

# Disable user list in gnome display manager
sed -i 's@# disable-user-list=true@disable-user-list=true@g' /etc/gdm3/greeter.dconf-defaults

# Set NFS share defenitions
sed -i '17i <volume user="*" fstype="nfs" server="snorlax.ijselu.local" path="/srv/homefolders/" mountpoint="/home/" options="soft" />' /etc/security/pam_mount.conf.xml
sed -i 's@mkhomedir.so@mkhomedir.so umask=0077 skel=/etc/skel@' /etc/pam.d/common-session

#Download Universal Forwarder
wget https://download.splunk.com/products/universalforwarder/releases/8.1.0/linux/splunkforwarder-8.1.0-f57c09e87251-Linux-x86_64.tgz

#Extract
tar xvzf splunkforwarder-8.1.0-f57c09e87251-Linux-x86_64.tgz -C /opt

#Configure Forwarder
/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd Cisco06! enable boot-start
/opt/splunkforwarder/bin/splunk enable deploy-client
/opt/splunkforwarder/bin/splunk set deploy-poll "10.100.0.6:8000"

#Firewall Config
ufw enable
ufw allow 8080
ufw allow 8000
ufw allow 5514
ufw allow 9997
ufw reload

#Splunk add monitoring logs
/opt/splunkforwarder/bin/splunk add forward-server 10.100.0.6:9997
/opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log
/opt/splunkforwarder/bin/splunk add monitor /var/log/kern.log
/opt/splunkforwarder/bin/splunk add monitor /var/log/lastlog

#Splunk Services Restart
/opt/splunkforwarder/bin/splunk restart