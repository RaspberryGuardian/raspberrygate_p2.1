#!/bin/sh

# Create Raspberry Guardian Install Directories.
# 
# by Hironobu SUZUKI

if [ ! -d /var ] ; then
    echo "This system has no /var directory. --- stop instillation"
    exit 1
fi

VARDIR="/var/rbg  /var/rbg/mode "
for dir in $VARDIR
do
    if [ ! -d $dir ] ; then
	echo 'Create ' $dir ' directory'
	mkdir $dir
    fi
done 

OPTDIRS="/opt /opt/rbg /opt/rbg/src /opt/rbg/bin /opt/rbg/etc /opt/rbg/lib"

for dir in $OPTDIRS
do
    if [ ! -d $dir  ] ; then
	echo 'Create ' $dir ' directory'
	mkdir $dir
    fi
done

