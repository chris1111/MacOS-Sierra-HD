#!/bin/bash
# MacOS Sierra HD
# (c) Copyright 2016 chris1111  

osascript ./Intro.app
Sleep 2

#debugging output
[ -f /tmp/debug ] && set -x 


clear;
echo "**********************************************  "
echo "Starting MacOS Sierra HD!  "   
echo "**********************************************  "


Sleep 2
osascript ./main.app

Sleep 3

echo "**********************************************  "
echo "Mount Installer image!  "
echo "**********************************************  "
Sleep 2
osascript -e 'display notification "MacOS Sierra HD" with title "OS Install Start"  sound name "default"'
		
       


Sleep 2
installer -allowUntrusted -verboseR -pkg /Volumes/OS\ X\ Install\ ESD/Packages/OSInstall.mpkg -target /Volumes/MacOS_HD

Sleep 5

echo "**********************************************  "
echo "Unmount Installer image!  "
echo "**********************************************  "
Sleep 2
hdiutil detach /Volumes/"OS X Install ESD"

Sleep 2
echo "**********************************************  "
echo "Volume rename Macintosh-HD  "
echo "**********************************************  "
/usr/sbin/diskutil rename "MacOS_HD" "Macintosh-HD"

open /Volumes/"Macintosh-HD"

Sleep 2


echo "Enjoy!  " 