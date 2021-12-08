#!/bin/bash
# Update system
dnf update -y

# Install Squid
dnf -y install squid

# Write config file changes
sed -i "18i acl blockedsites dstdomain \"/etc/squid/restricted-sites.squid\"" /etc/squid/squid.conf
sed -i "19i http_access deny blockedsites" /etc/squid/squid.conf

# Insert blocklist
cat >/etc/squid/restricted-sites.squid <<EOL
.youtube.com
.facebook.com
.netflix.com
.bing.com
.msn.com
EOL

# Add firewall rule
firewall-cmd --add-service=squid --permanent
firewall-cmd --reload

# Run Squid at startup
systemctl enable --now squid