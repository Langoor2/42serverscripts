#!/bin/bash
# update system
dnf -y update
# Install java and import  repo for elasticsearch
dnf -y install java-1.8.0-openjdk
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat >/etc/yum.repos.d/elasticsearch.repo  <<EOL
[elasticstack]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOL

# Update repo list and install required packages
dnf -y update
dnf -y install elasticsearch kibana logstash filebeat
# Configure networksettings for Elasticsearch
sed -i 's/#network.host: 0.0.0.0/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml
sed -i 's/#http.port: 9200/http.port: 9200/' /etc/elasticsearch/elasticsearch.yml
# Start Elasticsearch
systemctl start elasticsearch
systemctl enable elasticsearch
# Configure kibnana
sed -i 's/#server.port: 5601/server.port: 5601/' /etc/kibana/kibana.yml
sed -i 's/#server.host: "localhost"/server.host: "localhost"/' /etc/kibana/kibana.yml
sed -i 's@#elasticsearch.hosts: \["http://localhost:9200"\]@elasticsearch.hosts: \["http://localhost:9200"\]@' /etc/kibana/kibana.yml
# Start kibana
systemctl start kibana
systemctl enable kibana
# Allow remote access to kibana dashboard
firewall-cmd --add-port=5601/tcp --permanent
firewall-cmd --reload
# Start logstash
systemctl start logstash
systemctl enable logstash
# Enable filebeat
filebeat modules enable system
filebeat setup
# Start filebeat
systemctl start filebeat
systemctl enable filebeat