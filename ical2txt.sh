#!/bin/bash
FILE="$1"

DATE_START=`egrep "^DTSTART;TZID=" "${FILE}" | awk -F: '{ print $NF }' | cut -c 1-13` 
DATE_START=`date --date="${DATE_START}" "+%Y/%m/%d(%a) %H:%M"`

DATE_END=`egrep "^DTEND;TZID=" "${FILE}" | awk -F':' '{ print $NF }' | cut -c 1-13`
DATE_END=`date --date="${DATE_END}" "+%Y/%m/%d(%a) %H:%M"`

ORGANIZER=`egrep "^ORGANIZER;CN=" "${FILE}" | awk -F':' '{ print $NF }'`

ATTENDEE=`egrep -A 2 '^ATTENDEE' "${FILE}" | awk -F: '{ print $NF }' | egrep -v '^ATTENDEE'`

echo
echo "作成者: ${ORGANIZER}"
echo "  日時: ${DATE_START} 〜 ${DATE_END}"
echo "参加者: "
echo "${ATTENDEE}" | awk -F: '{ print $NF }' | egrep -v '^ATTENDEE' | sed -e 's/$/, /g' | tr -d '\n' | fold --space 
