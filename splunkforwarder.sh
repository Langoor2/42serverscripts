#!/bin/sh

#Update system
sudo apt update

#Download Universal Forwarder
sudo wget https://download.splunk.com/products/universalforwarder/releases/8.1.0/linux/splunkforwarder-8.1.0-f57c09e87251-Linux-x86_64.tgz

#Extract
sudo tar xvzf splunkforwarder-8.1.0-f57c09e87251-Linux-x86_64.tgz -C /opt

#Configure Forwarder
sudo /opt/splunkforwarder/bin/splunk --accept-license --answer-yes
sudo /opt/splunkforwarder/bin/splunk enable boot-start -user serviceaccount
sudo /opt/splunkforwarder/bin/splunk add user admin -password Cisco06! -role admin
sudo /opt/splunkforwarder/bin/splunk set deploy-poll "10.100.0.6:8000"
sudo /opt/splunkforwarder/bin/splunk enable deploy-client
sudo /opt/splunkforwarder/bin/splunk restart