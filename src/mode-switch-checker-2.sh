#!/bin/sh

SETBOOTFLAG='/opt/rbg/bin/set-boot-flag.sh'

GPIOS="23 24 25"

for gpio in $GPIOS
do
    echo $gpio > /sys/class/gpio/export
    echo in > /sys/class/gpio/gpio$gpio/direction
    echo high > /sys/class/gpio/gpio$gpio/direction
done

for gpio in $GPIOS
do
    VAL=`cat /sys/class/gpio/gpio$gpio/value`
    if [ $VAL -eq 0 -a $gpio -eq 23 ] ; then
	$SETBOOTFLAG 2
	exit 0
    fi
    if [ $VAL -eq 0 -a $gpio -eq 24 ] ; then
	$SETBOOTFLAG 0
	exit 0
    fi
    if [ $VAL -eq 0 -a $gpio -eq 25 ] ; then
	$SETBOOTFLAG 4
	exit 0
    fi
done

exit 0
