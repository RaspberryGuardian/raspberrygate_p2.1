#!/bin/sh


# Run mode: switch Raspberry Gate run mode when boot.
#
#

MODEDIR=/var/rbg/mode
BINDIR=/opt/rbg/bin
BOOTF=$MODEDIR/boot.cfg

if [ ! -f $BOOTF ] ; then
    echo 'No boot configure file for Raspberry Gate ...Bye.'
    exit 1
fi

grep -q NORMAL $BOOTF ; VALUE=$?

if [ $VALUE -eq 0 ] ; then
    # find 'NORMAL' and do nothing.
    exit 0
fi

grep -q MAINTENANCE $BOOTF ; VALUE=$?
if [ $VALUE -eq 0 ] ; then
    # find 'MAINTENANCE' and run rbg-update.sh
    cd /opt/rbg/src 
    nohup $BINDIR/rbg-update.sh &
    exit 0
fi

grep -q ROUTER $BOOTF ; VALUE=$?
if [ $VALUE -eq 0 ] ; then
    # find 'ROUTER' and run router
    grep -q default $MODEDIR/router.cfg; VALUE=$?
    if [ $VALUE -eq 0 ] ; then
	$BINDIR/router.sh
    else
	# This code for preventing directory traversal.
	CMDFILE=`sed -e 's/\// /g' $MODEDIR/router.cfg | rev | awk '{print $1}' | rev`
	if [ -x $BINDIR/$CMDFILE ] ; then
	    $BINDIR/$CMDFILE
	fi
    fi
    exit 0
fi

grep -q BRIDGE $BOOTF ; VALUE=$?
if [ $VALUE -eq 0 ] ; then
    # find 'BRIDGE' and do it.
    grep -q default $MODEDIR/bridge.cfg; VALUE=$?
    if [ $VALUE -eq 0 ] ; then
	$BINDIR/bridge.sh
    else
	# This code for preventing directory traversal.
	CMDFILE=`sed -e 's/\// /g' $MODEDIR/bridge.cfg | rev | awk '{print $1}' | rev`
	if [ -x $BINDIR/$CMDFILE ] ; then
	    $BINDIR/$CMDFILE
	fi
    fi
    exit 0
fi

exit 0
