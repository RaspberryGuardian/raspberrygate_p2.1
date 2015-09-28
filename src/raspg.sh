#! /bin/sh -e
### BEGIN INIT INFO
# Provides:          raspg
# Required-Start:    
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start Raspberry Guardian's Raspberry Gate.
# Description:       Raspberry Gate Boot Switcher -- System switch to NORMAL, MAINTENANCE, ROUTER, or  BRIDGE mode for Raspberry Gate.
### END INIT INFO


PATH=/opt/rbg/bin:/sbin:/usr/sbin:/bin:/usr/bin
DESC="Run Raspberry Gate"
NAME=raspg
BOOTSWITCHER="/opt/rbg/bin/run-mode.sh"
SCRIPTNAME=/etc/init.d/$NAME

[ -x "$BOOTSWITCHER" ] || exit 0


[ -r /etc/default/$NAME ] && . /etc/default/$NAME

. /lib/init/vars.sh

. /lib/lsb/init-functions

do_start()
{

    /opt/rbg/bin/mode-switch-checker.sh
    $BOOTSWITCHER ; VALUE=$?
    ## clear boot configuration file
    /bin/rm -f  /var/rbg/mode/*.cfg
    return $VALUE
}
do_stop()
{
	return 0
}



case "$1" in
  start)
	[ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
	do_start
	case "$?" in
		0) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		*) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  stop)
	[ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
	do_stop
	case "$?" in
		0) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		*) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  *)
	echo "Usage: $SCRIPTNAME {start|stop}" >&2
	exit 1
	;;
esac

exit 0
