#!/bin/sh

if [ -f /opt/rbg/lib/router-functions ; then
 . /opt/rbg/lib/router-functions
fi


#
# Stop ssh, ntp ( and others )
#

if [ -f /opt/rbg/bin/stop-deamon.sh ] ; then
    /opt/rbg/bin/stop-deamon.sh
fi

#
# Down network interface
#

ifconfig eth0 down
ifconfig eth1 down

## check iptable_nat module
MODULELOAD=`lsmod | grep iptable_nat | wc -l`
if [ $MODULELOAD -eq 0 ] ; then
    # I guess it alway success.
    modprobe iptable_nat
fi

# IPv4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# eth0 (WAN) network up with DHCP
dhclient eth0


#
# NTP start for LAN (eth1) side.
#

if [ -f /etc/ntp.conf ] ; then
    cp /etc/ntp.conf /opt/rbg/etc/ntp.conf
    grep -q 192.168.32.0 /etc/ntp.conf ; VALUE=$?
    if [ $VALUE -ne 0 ] ; then
	echo 'restrict 192.168.32.0 mask 255.255.255.0 nomodify notrap notrust' >> /opt/rbg/etc/ntp.conf
    fi
fi

ETH0ADDR=`ifconfig eth0 | sed -e 's/:/ /' | awk '/inet addr/ {print $3;}'`

if [ x${ETH0ADDR} !=  x ] ; then
##    service ntp start
    /usr/sbin/ntpd -g -u ntp:ntp -c /opt/rbg/etc/ntp.conf -p /var/run/ntpd.pid
fi

#
#


# eth1 (LAN) network setup.
ifconfig eth1 192.168.32.1 netmask 255.255.255.0

iptables --table nat --append POSTROUTING --out-interface eth0 --jump MASQUERADE
iptables --append FORWARD --in-interface eth1 --jump ACCEPT

## Chain RASPGROUTER for Raspberry Gate filtering.
iptables --new-chain RASPGROUTER
iptables --append INPUT --in-interface eth0 --jump RASPGROUTER

UDHCPDCONF=/opt/rbg/etc/udhcpd.conf

grep -v 'dns' /opt/rbg/etc/udhcpd-raspg.conf > $UDHCPDCONF
grep -e '^nameserver' /etc/resolv.conf | awk '{print "opt\tdns\t",  $2}' >> $UDHCPDCONF

if [ -x /usr/sbin/udhcpd -a -f $UDHCPDCONF ] ; then
    /usr/sbin/udhcpd $UDHCPDCONF
else
    echo 'udhcpd was not started because $UDHCPDCONF was not found.'
fi

exit 0
