#!/bin/sh

#Download Universal Forwarder
https://download.splunk.com/products/universalforwarder/releases/8.1.0/linux/splunkforwarder-8.1.0-f57c09e87251-Linux-x86_64.tgz

#Extract
tar xvzf /tmp/splunkforwarder-8.1.0-f57c09e87251-Linux-x86_64.tgz -C /opt

#Configure Forwarder
/opt/splunkforwarder/bin/splunk --accept-license --no-prompt --answer-yes enable boot-start -user serviceaccount
/opt/splunkforwarder/bin/splunk add user admin -password Cisco06! -role admin
/opt/splunkforwarder/bin/splunk set deploy-poll "10.100.0.6:8000"