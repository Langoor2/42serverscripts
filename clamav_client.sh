#!/bin/bash

# Installation of ClamAV
apt install clamav -y

# Installation of ClamAV Deamon
apt-get install clamav-daemon -y

# Stop ClamAV freshclam service
systemctl stop clamav-freshclam

# Update the signature database
freshclam

# Start ClamAV freshclam service
systemctl start clamav-freshclam

# Start ClamAV daemon service
systemctl start clamav-daemon

# Check status of the clamav freshclam service
systemctl status clamav-freshclam

# Check status ClamAV daemon service
systemctl status clamav-daemon