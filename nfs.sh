#!/bin/bash
# Update system
dnf update -y

# Install NFS
dnf install -y nfs-utils

# Create the folder to host the files
mkdir -p /srv/homefolders

# Create the share
cat >/etc/exports <<EOL
/srv/homefolders   *(rw,no_root_squash,no_subtree_check,no_wdelay,sync)
EOL

# Firewall rules
firewall-cmd --permanent --zone=public --add-service=nfs
firewall-cmd --reload

# Enable nfs
systemctl enable nfs-server.service
systemctl start nfs-server.service