#!/bin/bash
# MacOS Sierra HD
# chris1111 http://hackintosh-montreal.com

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
echo " "
echo "Installation  /Volumes/MacOS-HD  
Wait, be patient! . . . "
osascript ./Select.app

Sleep 3

echo "**********************************************  "
echo "Unmount Installer image!  "
echo "**********************************************  "
Sleep 2
hdiutil detach /tmp/Installer-OS

Sleep 2
echo "**********************************************  "
echo "Volume rename Macintosh-HD  "
echo "**********************************************  "
/usr/sbin/diskutil rename "MacOS-HD" "Macintosh-HD"

open /Volumes/"Macintosh-HD"

Sleep 2

echo "Enjoy!  " 