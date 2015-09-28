#!/bin/sh

INSTALL_LIST=`cat lib/apt-get-list.txt`

if [ ! -d /opt/rbg ] ; then
    # I guess this is first time to install into this environment
    apt-get install $INSTALL_LIST
fi

if [ ! -e /dev/hwrng ] ; then
    lib/add-module.sh 
fi

lib/create-dirs.sh

install src/* /opt/rbg/bin
install lib/* /opt/rbg/lib
install etc/* /opt/rbg/etc

install src/raspg.sh /etc/init.d/raspg
insserv raspg

lib/create-initvect.sh



exit 0
