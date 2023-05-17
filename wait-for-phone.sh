#!/bin/bash
#This script waits for a phone connection and then accesses its data.

LOCALPATH=$(pwd)
usbcount=$(lsusb | wc -l) 
newcount=$usbcount
#wait until phone is connected (not mounted)
echo 'Waiting for connection...'
while [ $usbcount -eq $newcount ]; do	
	newcount=$(lsusb | wc -l)
done

#mounts phone
gio mount -li | awk -F= '{if(index($2,"mtp") == 1)system("gio mount "$2)}'

#waits/checks if unlocked
echo 'Connected. Waiting for unlock...'
until [ -d $XDG_RUNTIME_DIR/gvfs/mtp:host=*/* ]; do
    if [ ! -d $XDG_RUNTIME_DIR/gvfs/mtp:host=* ]; then
    	gio mount -li | awk -F= '{if(index($2,"mtp") == 1)system("gio mount "$2)}'
    fi
done

#navigates to file system
cd $XDG_RUNTIME_DIR/gvfs/mtp:host=*/*
ls
echo 'FILE SYSTEM ACCESSED!'

cd "$LOCALPATH"
