#!/bin/bash
# Set DNS, IP, Proxy, NTP
# IP and DNS is set by DHCP.


# Update system


apt update -y && apt upgrade -y
apt install firefox thunderbird p7zip libreoffice sssd-ad sssd-tools realmd adcli



# Join domain
realm join treecko.ijselu.local

# Enable home dir creation
pam-auth-update --enable mkhomedir

# Mount /home on NFS
10.100.0.9:/srv/homefolders /home nfs defaults 0 0 >> /etc/fstab