#!/bin/bash
# Update system
dnf update -y
dnf -y install bind bind-utils

cat >/etc/named.conf <<EOL
zone "100.10.in-addr.arpa" IN {
        type master;
        file "ijselu.reverse";
        allow-update { none; };
}
;
EOL

cat >/etc/named.rfc1912.zones <<EOL
zone "100.10.in-addr.arpa" IN {
       type master;
       file "ijselu.reverse";
       allow-update { none; };
};
EOL

cat >/var/named/ijselu.forward <<EOL
$TTL 86400
@   IN  SOA     amoonguss.ijselu.local. root.ijselu.local. (
                                              3           ;Serial
                                              3600        ;Refresh
                                              1800        ;Retry
                                              604800      ;Expire
                                              86400       ;Minimum TTL
)

;Name Server Information
@       IN  NS      amoonguss.ijselu.local.

;IP address of Name Server
amoonguss       IN  A       10.100.0.3

;A - Record HostName To Ip Address
@           IN  A       10.100.0.13
treecko     IN  A       10.100.0.2
_ldap._tcp.ijselu.local. IN SRV 10 50 389 treecko.ijselu.local.
amoonguss   IN  A       10.100.0.3
psyduck     IN  A       10.100.0.4
exxeggcute  IN  A       10.100.0.5
furret      IN  A       10.100.0.6
octillery   IN  A       10.100.0.7
meowth      IN  A       10.100.0.8
snorlax     IN  A       10.100.0.9
celebi      IN  A       10.100.0.10
;charizard   IN  A       10.100.0.11
jigglypuff  IN  A       10.100.0.12
oddish      IN  A       10.100.0.13
moodle.ijselu.local.      IN  CNAME   psyduck.ijselu.local.
EOL

cat >/var/named/ijselu.reverse <<EOL
$TTL 86400
@   IN  SOA     amoonguss.ijselu.local. root.ijselu.local. (
                                       3           ;Serial
                                       3600        ;Refresh
                                       1800        ;Retry
                                       604800      ;Expire
                                       86400       ;Minimum TTL
)

;Name Server Information
@         IN      NS         amoonguss.ijselu.local.

;Reverse lookup for Name Server
0.3       IN  PTR     amoonguss.ijselu.local.

;PTR Record IP address to HostName
0.2      IN  PTR     treecko.ijselu.local.
0.3      IN  PTR     amoonguss.ijselu.local.
0.4      IN  PTR     psyduck.ijselu.local.
0.5      IN  PTR     exxeggcute.ijselu.local.
0.6      IN  PTR     furret.ijselu.local.
0.7      IN  PTR     octillery.ijselu.local.
0.8      IN  PTR     meowth.ijselu.local.
0.9      IN  PTR     snorlax.ijselu.local.
0.10     IN  PTR     celebi.ijselu.local.
;0.11     IN  PTR     charizard.ijselu.local.
0.12     IN  PTR     jigglypuff.ijselu.local.
0.13     IN  PTR     oddish.ijselu.local.
EOL

systemctl start named
systemctl enable named