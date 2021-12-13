#!/bin/bash

# Install the EPEL repository
dnf install epel-release -y

# Installing clamAV and clamd
dnf install clamav -y
dnf install clamd -y
dnf install clamav clamd clamav-update -y

# Adjust SELinux (Secure Linux)
setsebool -P antivirus_can_scan_system 1

# Get the antivirus signatures
freshclam

# ClamAV configuration
sed -i 's/#LocalSocket \/run/LocalSocket \/run/g' /etc/clamd.d/scan.conf

echo "
[Unit]
Description = ClamAV Scanner
After = network.target

[Service]
Type = forking
ExecStart = /usr/bin/freshclam -d -c 1
Restart = on-failure
PrivateTmp = true

[Install]
WantedBy = multi-user.target
" >> /usr/lib/systemd/system/freshclam.service

# Reload daemon service
systemctl daemon-reload

# Enable and start the clamd and freshclan services
systemctl start clamd@scan

systemctl start freshclam

systemctl enable clamd@scan

systemctl enable freshclam

# Check the clamAV service status

systemctl status clamd@scan

systemctl status freshclam

echo "Installation completed"