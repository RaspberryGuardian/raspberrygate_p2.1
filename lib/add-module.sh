#!/bin/sh

if [  -e /dev/hwrng ] ; then
    exit 0
fi
modprobe bcm2708-rng ;  VALUE=$?

if [ $VALUE -eq 1 ] ; then
    echo 'Error occurred: modprobe bcm2708-rng'
    exit 1
fi

grep -q bcm2708-rng /etc/modules ; VALUE=$?
if [ $VALUE -eq 1 ] ; then
    echo '#### Added by Rasberry Gate Installer' >> /etc/modules
    echo 'bcm2708-rng' >> /etc/modules
fi


exit 0

