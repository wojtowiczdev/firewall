#!/bin/sh
# Start/stop the cron daemon.
#
### BEGIN INIT INFO
# Provides:          cron
# Required-Start:    $remote_fs $syslog $time
# Required-Stop:     $remote_fs $syslog $time
# Should-Start:      $network $named slapd autofs ypbind nscd nslcd winbind sssd
# Should-Stop:       $network $named slapd autofs ypbind nscd nslcd winbind sssd
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Regular background program processing daemon
# Description:       cron is a standard UNIX program that runs user-specified 
#                    programs at periodic scheduled times. vixie cron adds a 
#                    number of features to the basic UNIX cron, including better
#                    security and more powerful configuration options.
### END INIT INFO
echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -F
iptables -X

iptables -t nat -X
iptables -t nat -F

iptables -t mangle -F
iptables -t mangle -X

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

iptables -t nat -A FORWARD -j ACCEPT -m state --state ESTABLISHED,RELATED
iptables -t nat -A OUTPUT -j ACCEPT -m state --state ESTABLISHED,RELATED
iptables -t nat -A INPUT -j ACCEPT -m state --state ESTABLISHED,RELATED

iptables -t nat -A PREROUTING -s 172.19.1.0/24  -p tcp --dport 80 -j REDIRECT --to-port 3129
iptables -A INPUT -p tcp --dport 3129 -s 172.19.1.0/24 -j ACCEPT

iptables -t nat -A POSTROUTING -s 172.19.1.0/24 -j MASQUERADE
iptables -A FORWARD -s 172.19.1.0/24 -j ACCEPT



