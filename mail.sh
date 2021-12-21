#!/bin/bash
# Update repo's and system
apt update && apt upgrade -y && apt dist-upgrade -y
apt install -y postfix 