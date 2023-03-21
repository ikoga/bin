#!/bin/bash
LANG=C
BATTERY_DIR="BAT1"
WARN=30

#calc_bm () {
#   remain=`cat /proc/acpi/battery/${BATTERY_DIR}/state | grep 'remaining' | sed -e 's/^.*: *//' -e 's/ mWh$//'`
#   full=`cat /proc/acpi/battery/${BATTERY_DIR}/info | grep 'last full' | sed -e 's/^.*: *//' -e 's/ mWh$//'`
##   full=`cat /proc/acpi/battery/${BATTERY_DIR}/info | grep 'design capacity:' | awk '{ print $3 }'`
#   percent=$(( remain * 100 / full ))
#   echo $percent
#}
# BATSTAT=`calc_bm`
#
BATSTAT=`fgrep "POWER_SUPPLY_CAPACITY=" /sys/class/power_supply/BAT1/uevent | awk -F '=' '{ print $2 }'`
if [ $BATSTAT -lt $WARN ]; then
   echo -n "Warning! ${BATSTAT}%"
else
   echo -n "${BATSTAT}%"
fi


STATE=`cat /sys/class/power_supply/BAT1/status`
if [ "$STATE" = "Charged" ]; then
   echo -n " 充電済"

elif [ "$STATE" = "Charging" ]; then
   echo -n " 充電中"

elif [ "$STATE" = "Discharging" ]; then
   echo -n " 放電中"

else
   echo -n "[?]"

fi


## Wi-Fi Frequency
FREQ="`iwconfig 2>/dev/null | fgrep Frequency: | egrep -o '[[:digit:]]\.+[[:digit:]]+'`"
if [ "${FREQ}" = "" ]; then
   true
else
   echo -n " ${FREQ}GHz"
fi
