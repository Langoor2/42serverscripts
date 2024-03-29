#!/bin/bash

# Update system
dnf update -y

# Install packages
dnf -y install chrony

# Write the config file to allow servers to access the server
echo 'allow 10.100.0.0/16' >> /etc/chrony.conf


# Allow access through the firewall
firewall-cmd --permanent --add-service=ntp
firewall-cmd --reload

# Start and enable the service at bootup
systemctl enable chronyd
systemctl start chronyd