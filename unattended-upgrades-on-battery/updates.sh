#!/bin/bash

# Run the unattended-upgrades if machine running on battery, perfect for laptop
#
# First ensure that you have to allow unattended-upgrades and apt update to be execute without sudo :
# Requirement :
#    Unattended-upgrades installed and enabled
#    Allow unattended-upgrades and apt update to be execute without prompt password with this :
#        whereis unattended-upgrades
#        whereis apt
#        sudo visudo -f /etc/sudoers.d/custom
#        UserName ALL=NOPASSWD: /path of the command to/unattended-upgrades
#        UserName ALL=NOPASSWD: /path of the command to/apt update
#
# Set this script to be started at login
#
# Tested succesfull on Ubuntu 14.04 and 16.04
# This script is supposed to be start at login
# Philippe734 - 2017

# Begin of the script

# Run unattended-upgrades on battery if > 70% after 6 minutes
sleep 6m

level=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)
lastupdate=$(cat /var/log/unattended-upgrades/unattended-upgrades.log | grep `date -I` | tail -1)

# Exit if not discharging
if [ "${status}" != "Discharging" ]; then
  exit 0
fi

# Exit if updated today
if [ -n "$lastupdate" ]; then
  exit 0
fi

# Update
if [ "${level}" -ge 70 ]; then  
	sudo apt update && sudo unattended-upgrades
fi
