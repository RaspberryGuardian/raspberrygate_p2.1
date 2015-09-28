#!/bin/sh

MODEDIR=/var/rbg/mode
BOOTF=$MODEDIR/boot.cfg

case "$1" in
    0)
	echo NORMAL > $BOOTF
	;;

    1)
	echo MAINTENANCE > $BOOTF
	;;

    2)
	echo ROUTER > $BOOTF
	echo default > $MODEDIR/router.cfg
	;;
    3)
	echo BRIDGE > $BOOTF
	echo default > $MODEDIR/bridge.cfg
	;;

    4)
	echo BRIDGE > $BOOTF
	echo secure-bridge.sh > $MODEDIR/bridge.cfg
	;;

    *)
	echo "Usage: set-boot-flag.sh {0|1|2|3|4}" >&2
	echo " 0: normal mode" >&2
	echo " 1: maintenance mode" >&2
	echo " 2: router mode" >&2
	echo " 3: bridge mode" >&2
	echo " 4: secure bridge mode" >&2
	exit 1
	;;
esac
sync;sync;sync
exit 0

