#!/bin/sh

echo 'UNINSTALL RASPBERRY GATE. I MEAN REMOVE "/opt/rbg" DIRECTORY. '
echo 'IF YOU STOP IT, TYPE CONTROL-C NOW.'
sleep 10
echo -n 'REMOVING ALL FILES...'
rm -fr /opt/rbg
insserv --remove raspg

if [ -f /etc/init.d/raspg ] ; then
    rm /etc/init.d/raspg
fi
ech 'DONE'
exit 0



