sudo dnf install wget -y


groupadd splunk
useradd -d /opt/splunk -m -g splunk splunk
su - splunk
id
getconf LONG_BIT


wget https://download.splunk.com/products/splunk/releases/8.1.0/linux/splunk-8.1.0-f57c09e87251-Linux-x86_64.tgz


tar xvzf splunk-8.1.0-f57c09e87251-Linux-x86_64.tgz -C /opt
cd /
ls
cd opt
ls
cd splunk
ls
chown -R splunk: /opt/splunk/
ls
cd /
cd opt/splunk/bin
ls
./splunk start --accept-license --answer-yes --no-prompt --seed-passwd Cisco06!

su
<wachtwoord>
sudo ./splunk enable boot-start


http://10.100.0.6:8000

firewall-cmd --zone=public --permanent --add-port 8080/tcp
firewall-cmd --zone=public --permanent --add-port 8000/tcp
firewall-cmd --zone=public --permanent --add-port 5514/udp
firewall-cmd --reload

reboot
