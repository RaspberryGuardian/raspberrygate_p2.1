#!/bin/sh
COUNT=0
GPIODIR=/sys/class/gpio/gpio18
VALFILE=$GPIODIR/value
#### Setup gpio 18
echo 18 > /sys/class/gpio/export
echo in > $GPIODIR/direction
echo high > $GPIODIR/direction
while true 
do
    if [ $COUNT -gt 6 ] ; then
	/sbin/shutdown  -h now
    fi
    if [ ! -e $VALFILE ] ; then
	exit 1
    fi
    VAL=`cat $VALFILE`
    if [ $VAL -eq 0 ] ; then
	COUNT=`expr $COUNT + 1`
    else
	COUNT=0
    fi
    sleep 0.5
done
