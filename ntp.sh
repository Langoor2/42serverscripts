#!/bin/bash

# Update system
dnf update -y

# Install packages
dnf -y install chrony

allow 10.100.0.0/16 >> /etc/chrony.conf





firewall-cmd --permanent --add-service=ntp
firewall-cmd --reload

systemctl enable chronyd
systemctl start chronyd