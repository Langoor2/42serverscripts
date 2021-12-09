#!/bin/bash
# Set DNS, IP, Proxy, NTP
# IP and DNS is set by DHCP.

# Fix repositorys
sed -i 's#nl.archive.ubuntu.com#old-releases.ubuntu.com#' /etc/apt/sources.list
sed -i 's#security.ubuntu.com#old-releases.ubuntu.com#' /etc/apt/sources.list

# Update system

apt update -y && apt upgrade -y
apt -y install firefox thunderbird p7zip libreoffice sssd-ad sssd-tools realmd adcli ntp

sed -i 's/pool/#pool/' /etc/ntp.conf
echo 'server 10.100.0.10' >> /etc/ntp.conf

# Join domain
realm join treecko.ijselu.local

# Enable home dir creation
pam-auth-update --enable mkhomedir

# Disable user list in gnome display manager
sed -i 's@# disable-user-list=true@disable-user-list=true@g' /etc/gdm3/greeter.dconf-defaults

# Mount /home on NFS
10.100.0.9:/srv/homefolders /home nfs defaults 0 0 >> /etc/fstab