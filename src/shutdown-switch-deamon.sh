#!/bin/sh 
#
# Shutdown Switch is assigned dip-4th switch.
# if dip-4th switch is down, then go shutdown mode.
#
# 1   2   3   4    5   6   7   8
# down  any any any any any any 
#

# 

STATCMD=/opt/raspg/bin/switch-stat.sh

if [ ! -x $STATCMD ] ; then
    echo NO $STATCMD
    exit 1
fi
while true 
do
    value=`$STATCMD`
    shutdownflag=`echo "($value % 64)/32" | bc`
    if [ $shutdownflag -eq 1 ] ; then
	uptime_value=`awk '{ printf "%d",$1}' /proc/uptime`
	if [ $uptime_value -gt 60 ] ; then
	    shutdown -h now
	else
	    echo -n 'Waiting shutdown until uptime become over '
	    expr 60 - $uptime_value
	    echo ' seconds'
	    sleep 5
	fi
    fi
    sleep 1
done

exit 0
