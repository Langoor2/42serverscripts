#!/bin/bash
# Update system
dnf update -y

dnf -y install httpd php php-common


cat >/var/www/html/index.php <<EOL
<h1>Welkom op de website van de Universiteit van Deventer</h1>
<p>De webmaster is druk bezig met een nieuwe website!</p>
<a href="http://moodle.ijselu.local">Ga naar de ELO</a>
EOL

# firewall rules
firewall-cmd --add-port=80/tcp --zone=public --permanent
firewall-cmd --add-port=443/tcp --zone=public --permanent
firewall-cmd --reload

# enable at boot
systemctl restart httpd
systemctl enable httpd
