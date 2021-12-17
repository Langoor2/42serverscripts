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