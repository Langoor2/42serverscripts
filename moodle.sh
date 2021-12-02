#!/bin/bash

# Update system
dnf update
# installing packages
dnf install -y httpd mariadb-server mariadb php php-common php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-gd php-mbstring php-xml
# making mysql secureTM
systemctl start mariadb
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
#mysql -e "DROP DATABASE test;DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';"
mysql -e "CREATE DATABASE moodledb;"
mysql -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodledb.* TO 'moodleadmin'@'localhost' IDENTIFIED BY 'herpderp'"
mysql -e "SET PASSWORD FOR root@localhost = PASSWORD('herpderp');FLUSH PRIVILEGES;"
# get and extract moodle
wget -c https://download.moodle.org/download.php/direct/stable311/moodle-3.11.4.tgz
tar -xzf moodle-3.11.4.tgz -C /var/www/
chmod 775 -R /var/www/moodle
chown apache:apache -R /var/www/moodle
mkdir -p /var/www/moodledata
chmod 770 -R /var/www/moodledata
chown apache:apache -R /var/www/moodledata
cp /var/www/moodle/config-dist.php /var/www/moodle/config.php

# edit config to our SQL configuration
sed -i 's\$CFG->dbtype    = '\''pgsql'\'';\$CFG->dbtype    = '\''mariadb'\'';\' /var/www/moodle/config.php
sed -i 's\$CFG->dbname    = '\''moodle'\'';\$CFG->dbname    = '\''moodledb'\'';\' /var/www/moodle/config.php
sed -i 's\$CFG->dbuser    = '\''username'\'';\$CFG->dbuser    = '\''moodleadmin'\'';\' /var/www/moodle/config.php
sed -i 's\$CFG->dbpass    = '\''password'\'';\$CFG->dbpass    = '\''herpderp'\'';\' /var/www/moodle/config.php
sed -i 's#$CFG->wwwroot   = '\''http://example.com/moodle'\'';#$CFG->wwwroot   = '\''http://ijselu.local/moodle'\'';#' /var/www/moodle/config.php
sed -i 's#$CFG->dataroot  = '\''\/home\/example\/moodledata'\'';#$CFG->dataroot  = '\''\/var\/www\/moodledata'\'';#' /var/www/moodle/config.php

# firewall rules
firewall-cmd --add-port=80/tcp --zone=public --permanent
firewall-cmd --add-port=443/tcp --zone=public --permanent
firewall-cmd --reload