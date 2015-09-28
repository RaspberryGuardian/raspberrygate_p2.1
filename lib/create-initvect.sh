#!/bin/sh
if [ -f /opt/rbg/etc/initvec ] ; then
    # already setup
    exit 0
fi

if [ ! -f /opt/rbg/lib/add-module.sh ] ; then
    # Raspberry Gate is not installed.
    echo 'Raspberry Gate is not installed...bye'
    exit 1
fi

/bin/sh /opt/rbg/lib/add-module.sh

dd if=/dev/hwrng of=/opt/rbg/etc/initvec bs=1K count=8

echo 'Raspberry Gate: /opt/rbg/etc/initvec was created.'

IDKEY=`(ifconfig eth0 | grep HWaddr | awk '{printf "%s", $5;}' ; echo 'idkey-1') | sha256sum  | cut -c-16`
SECKEY=`(ifconfig eth0 | grep HWaddr | awk '{printf "%s", $5;}' ; cat /opt/rbp/etc/initvect) | sha256sum  | cut -c-16`


(echo '### Raspberry Gate KEY KEYINIT ' ; echo 'IDKEY ' $IDKEY ; echo 'SECKEY ' $SECKEY) >> /opt/rbg/etc/rbg.conf

chmod 600 /opt/rbg/etc/rbg.conf

exit 0