#!/bin/sh

SERVICE=/usr/sbin/service

if [ ! -x $SERVICE ] ; then
    echo $SERVICE ' is not found ... bye'
    exit 1
fi

# To stop some daemon
#
#

DAEMONS="ssh ntp"

for daemon in $DAEMONS
do
    $SERVICE $daemon status 2> /dev/null > /dev/null ; VALUE=$?
    if [ $VALUE -eq 0 ] ; then
	$SERVICE $daemon stop
    fi
done

FORCE_KILL_DAEMONS="dhclient"

for daemon in $FORCE_KILL_DAEMONS
do
    killall $daemon 2> /dev/null > /dev/null
done


exit 0
