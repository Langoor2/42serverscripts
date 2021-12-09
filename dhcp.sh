#!/bin/bash

# Update system
dnf update -y

# Install packages
dnf -y install dhcp-server

cat >/etc/dhcp/dhcpd.conf  <<EOL
default-lease-time 600;
max-lease-time 7200;
ddns-update-style none;
authoritative;
subnet 10.100.0.0 netmask 255.255.0.0 {
  range 10.100.100.0 10.100.100.254;
  option routers 10.100.0.1;
  option subnet-mask 255.255.0.0;
  option domain-name-servers 10.100.0.3;
}
EOL

# Start and enable dhcpd at boot
systemctl start dhcpd
systemctl enable dhcpd

# Enable firewall access
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload