#!/bin/bash
LANG=C
BATTERY_DIR="BAT1"
WARN=30

calc_bm () {
   remain=`cat /proc/acpi/battery/${BATTERY_DIR}/state | grep 'remaining' | sed -e 's/^.*: *//' -e 's/ mWh$//'`
   full=`cat /proc/acpi/battery/${BATTERY_DIR}/info | grep 'last full' | sed -e 's/^.*: *//' -e 's/ mWh$//'`
#   full=`cat /proc/acpi/battery/${BATTERY_DIR}/info | grep 'design capacity:' | awk '{ print $3 }'`
   percent=$(( remain * 100 / full ))
   echo $percent
}

BATSTAT=`calc_bm`
if [ $BATSTAT -lt $WARN ]; then
   echo -n "Warning! ${BATSTAT}%"
else
   echo -n "${BATSTAT}%"
fi


STATE=`fgrep "charging state" /proc/acpi/battery/${BATTERY_DIR}/state | awk '{ print $NF }'`
if [ "$STATE" = "charged" ]; then
   echo -n " 充電済"

elif [ "$STATE" = "charging" ]; then
   echo -n " 充電中"

elif [ "$STATE" = "discharging" ]; then
   echo -n " 放電中"

else
   echo -n "[?]"

fi

# tenki.sh
# echo -n " "
# cat /var/tmp/tenki.txt | tr -d '\n'
echo -n " "
cat /var/tmp/cal.txt


## Wi-Fi Frequency
FREQ="`iwconfig 2>/dev/null | fgrep Frequency: | egrep -o '[[:digit:]]\.+[[:digit:]]+'`"
if [ "${FREQ}" = "" ]; then
   true
else
   echo -n " ${FREQ}GHz"
fi
