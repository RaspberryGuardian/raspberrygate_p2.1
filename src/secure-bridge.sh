#!/bin/sh

IPT=/sbin/iptables 
BRIDGEBASE=/opt/rbg/bin/bridge.sh

if [ ! -f $BRIDGEBASE ] ; then
    echo 'Not found: $BRIDGEBASE'
    exit 1
fi

$BRIDGEBASE

$IPT --new-chain RASPGBRIDGEIN
$IPT --append INPUT -i eth0 --jump RASPGBRIDGEIN
$IPT -A RASPGBRIDGEIN --protocol tcp --dport 22 -j DROP

$IPT --new-chain RASPGBRIDGEOUT
$IPT --append OUTPUT -o eth0 --jump RASPGBRIDGEOUT

$IPT -A RASPGBRIDGEOUT -d 10.0.0.0/255.0.0.0 -j ACCEPT
$IPT -A RASPGBRIDGEOUT -d 172.16.0.0/255.240.0.0 -j ACCEPT
$IPT -A RASPGBRIDGEOUT -d 192.168.0.0/255.255.0.0 -j ACCEPT
$IPT -A RASPGBRIDGEOUT -j DROP

exit 0
