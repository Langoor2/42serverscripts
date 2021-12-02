#!/bin/bash

# Update system
dnf Update
dnf install httpd mariadb-server mariadb-client
mysql -e "SET PASSWORD FOR root@localhost = PASSWORD('herpderp');FLUSH PRIVILEGES;"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DROP DATABASE test;DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';"
