#!/bin/sh


#Download Universal Forwarder
wget https://download.splunk.com/products/universalforwarder/releases/8.1.0/linux/splunkforwarder-8.1.0-f57c09e87251-Linux-x86_64.tgz


#Extract
tar xvzf splunkforwarder-8.1.0-f57c09e87251-Linux-x86_64.tgz -C /opt


#Configure Forwarder
./opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd Cisco06! enable boot-start
./opt/splunkforwarder/bin/splunk enable deploy-client
./opt/splunkforwarder/bin/splunk set deploy-poll "10.100.0.6:8000"


#Splunk Configure Boot Start
./opt/splunkforwarder/bin/splunk enable boot-start


#Firewall Config
ufw enable
ufw allow 8080
ufw allow 8000
ufw allow 5514
ufw allow 9997
ufw reload


#Splunk add monitoring logs
./opt/splunkforwarder/bin/splunk add forward-server 10.100.0.6:9997
./opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log
./opt/splunkforwarder/bin/splunk add monitor /var/log/kern.log
./opt/splunkforwarder/bin/splunk add monitor /var/log/lastlog


#Splunk Services Restart
./opt/splunkforwarder/bin/splunk restart
