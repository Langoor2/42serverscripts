#!/bin/bash
# update system
dnf -y update
# install packages
dnf -y install postfix postfix-mysql httpd vim policycoreutils-python-utils mariadb mariadb-server epel-release
dnf -y install php-common php-json php-xml php-mbstring php-mysqlnd

# configure mariadb
systemctl start mariadb
mysql -e "create database postfix_accounts;"
mysql -e "grant all on postfix_accounts.* to postfix_admin@localhost identified by 'StrongPassword';"
mysql -e "CREATE TABLE `postfix_accounts`.`domains_table` ( `DomainId` INT NOT NULL AUTO_INCREMENT , `DomainName` VARCHAR(50) NOT NULL , PRIMARY KEY (`DomainId`)) ENGINE = InnoDB;"

mysql <<EOF
CREATE TABLE `postfix_accounts`.`accounts_table` ( 
    `AccountId` INT NOT NULL AUTO_INCREMENT,  
    `DomainId` INT NOT NULL,  
    `password` VARCHAR(300) NOT NULL,   
    `Email` VARCHAR(100) NOT NULL,  
    PRIMARY KEY (`AccountId`),  
    UNIQUE KEY `Email` (`Email`),  
    FOREIGN KEY (DomainId) REFERENCES domains_table(DomainId) ON DELETE CASCADE 
) ENGINE = InnoDB;
EOF

mysql <<EOF
CREATE TABLE `postfix_accounts`.`alias_table` ( 
    `AliasId` INT NOT NULL AUTO_INCREMENT, 
    `DomainId` INT NOT NULL, 
    `Source` varchar(100) NOT NULL,  
    `Destination` varchar(100) NOT NULL,  
    PRIMARY KEY (`AliasId`), 
    FOREIGN KEY (DomainId) REFERENCES domains_table(DomainId) ON DELETE CASCADE 
) ENGINE = InnoDB;
EOF

mysql -e "INSERT INTO `postfix_accounts`.`domains_table` (DomainName) VALUES ('ijselu.local');"
INSERT INTO `postfix_accounts`.`accounts_table` (DomainId, password, Email) VALUES (1, ENCRYPT('Password', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'mark@ijselu.local'); 
mysql -e "create database roundcube;"
mysql -e "grant all on roundcube.* to roundcube_admin@localhost identified by 'StrongPassword';"

mysql -e "flush privileges;"