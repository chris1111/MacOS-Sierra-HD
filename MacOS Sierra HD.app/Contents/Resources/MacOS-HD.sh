#!/bin/bash
# MacOS Sierra HD
# chris1111 

osascript ./Intro.app
Sleep 2

#debugging output
[ -f /tmp/debug ] && set -x 

# Vars
apptitle="MacOS Sierra HD"
version="2.2"
#get usbdiskpath Installer path
# Set Icon directory and file 
iconfile="/System/Library/CoreServices/Installer.app/Contents/Resources/Installer.icns"

clear;
echo "**********************************************  "
echo "Starting MacOS Sierra HD!  "   
echo "**********************************************  "
if [[ $(mount | awk '$3 == "/Volumes/MacOS-HD" {print $3}') != "" ]]; then
 /usr/sbin/diskutil rename "MacOS-HD" "MacOSHD"
fi

Sleep 2
osascript ./main.app

Sleep 2

echo "**********************************************  "
echo "Mount Installer image!  "
echo "**********************************************  "
Sleep 2
osascript -e 'display notification "MacOS Sierra HD" with title "OS Install Start"  sound name "default"'
		      
Sleep 2
osascript ./Select.app
Sleep 2
# Select Deploy
response=$(osascript -e 'tell app "System Events" to display dialog "Select Deploy 
to choose your SSD or Disk.\n\nSelect Cancel to Quit" buttons {"Cancel","Deploy"} default button 2 with title "'"$apptitle"' '"$version"'" with icon POSIX file "'"$iconfile"'"  ')

action=$(echo $response | cut -d ':' -f2)



  # Get input folder of usbdisk disk 
  usbdiskpath=`/usr/bin/osascript << EOT
    tell application "Finder"
        activate
        set folderpath to choose folder default location "/Volumes" with prompt "Select your SSD / or Disk and click Choose"
    end tell 
    return (posix path of folderpath) 
  EOT`

  # Cancel is user selects Cancel
  if [ ! "$usbdiskpath" ] ; then
    osascript -e 'display notification "Program closing" with title "'"$apptitle"'" subtitle "User cancelled"'
    exit 0
  fi


# Parse usbdisk disk volume
usbdisk=$( echo $usbdiskpath | awk -F '\/Volumes\/' '{print $2}' | cut -d '/' -f1 )
disknum=$( diskutil list | grep "$usbdisk" | awk -F 'disk' '{print $2}' | cut -d 's' -f1 )
devdisk="/dev/disk$disknum"
# use rdisk for faster copy
devdiskr="/dev/rdisk$disknum"
# Get Drive size
drivesize=$( diskutil list | grep "disk$disknum" | grep "0\:" | cut -d "*" -f2 | awk '{print $1 " " $2}' )

# Set output option
if [ "$action" == "Deploy" ] ; then
  source=$inputfile
  dest="$drivesize $usbdisk (disk$disknum)"
  outputfile=$devdiskr
  check=$source
fi

# Confirmation Dialog
response=$(osascript -e 'tell app "System Events" to display dialog "Please confirm your choice and click OK\n\nDestination: \n'"$dest"' \n\n\nNOTE: MacOS Will be Deploy on the Disk!
At the end of the process the disk will be rename Macintosh-HD." buttons {"Cancel", "OK"} default button 2 with title "'"$apptitle"' '"$version"'" with icon POSIX file "'"$iconfile"'" ')
answer=$(echo $response | grep "OK")  

# Cancel is user does not select OK
if [ ! "$answer" ] ; then
  osascript -e 'display notification "Program closing" with title "'"$apptitle"'" subtitle "User cancelled"'
  exit 0
fi

/usr/sbin/diskutil rename "$usbdiskpath" "MacOS-HD"
echo " "
echo "Installation  /Volumes/MacOS-HD  
Wait, be patient! . . . "

Sleep 2

# run the pkg
osascript -e 'do shell script "installer -allowUntrusted -verboseR -pkg /tmp/Installer-OS/Packages/OSInstall.mpkg -target /Volumes/MacOS-HD" with administrator privileges'

# Exit if Canceled
if [ ! "$action" ] ; then
  osascript -e 'display notification "Program closing" with title "'"$apptitle"'" subtitle "User cancelled"'
  exit 0
fi

echo "  "
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