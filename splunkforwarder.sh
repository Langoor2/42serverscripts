#!/bin/sh

#Update system
sudo apt update


#Download Universal Forwarder
sudo wget https://download.splunk.com/products/universalforwarder/releases/8.1.0/linux/splunkforwarder-8.1.0-f57c09e87251-Linux-x86_64.tgz


#Extract
sudo tar xvzf splunkforwarder-8.1.0-f57c09e87251-Linux-x86_64.tgz -C /opt


#Configure Forwarder
sudo /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd Cisco06! enable boot-start
#sudo /opt/splunkforwarder/bin/splunk add user admin -password Cisco06! -role admin
sudo /opt/splunkforwarder/bin/splunk enable deploy-client
sudo /opt/splunkforwarder/bin/splunk set deploy-poll "10.100.0.6:8000"


#Firewall Config
sudo ufw enable
sudo ufw allow 8080
sudo ufw allow 8000
sudo ufw allow 5514
sudo ufw reload


#Splunk Services Restart
sudo /opt/splunkforwarder/bin/splunk restart

#Splunk Configure Boot Start
sudo /opt/splunkforwarder/bin/splunk enable boot-start