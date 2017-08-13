#!/bin/bash
# $Id$
LANG=ja_JP.UTF-8
VERSION_INFO="1.03"
BITRATE=128

which cdparanoia >/dev/null 2>&1
if [ "$?" = "1" ]; then
   echo "ERROR: cdparanoia is not installed"
   exit 2
fi

which lame >/dev/null 2>&1
if [ "$?" = "1" ]; then
   echo "ERROR: lame is not installed"
   exit 4
fi


usage ()
{
cat << _EOL_ 2>/dev/null
$VERSION_INFO
Usage: $0 [option ...] [outdir]
   OPTIONS
     -b kbps      set encode bit rate (default ${BITRATE}kbps)
     -c           keep CD in tray
     -k           keep original file
     -t track#    extract specified track number

     -h           display this help and exit
     -v           output version information and exit

To report bugs or request, please mail to koga <koga@iij.ad.jp>.
_EOL_
}

while getopts "ab:ckt:hv" opt
do
   case $opt in
     b) BITRATE=${OPTARG} ;;
     c) KEEP_CD="1"       ;;
     k) KEEP_ORG="1"      ;;
     t) TRACK="${OPTARG}" ;;
     h) usage
        exit 0            ;;
     v) echo "$VERSION_INFO"
        exit 0            ;;
   esac
done

shift $(($OPTIND - 1))
if [ "$1" = "" ]; then
   OUTDIR=`date "+%Y%m%d-%H%m%S"`
else
   OUTDIR="$1"
fi


echo "Output directory: ${OUTDIR}" | grep --color .

if [ -d "${OUTDIR}" ]; then
   read -p "Directory exists. Continue? "
else
   mkdir "${OUTDIR}" || exit 1
fi
cd "${OUTDIR}"

if [ "${TRACK}" = "" ]; then
   cdparanoia -B || exit 1
else
   cdparanoia -B "${TRACK}" || exit 1
fi

if [ "${KEEP_CD}" != "1" ]; then
   eject || echo "ERROR: counld not eject CD tray"
fi

for FILE in `ls -1 *.wav`
do
   F=`basename "${FILE}" .cdda.wav`
   lame --cbr -b "${BITRATE}" -q0 "${FILE}" "${F}.mp3"
done

if [ "${KEEP_ORG}" != "1" ]; then
   rm -f *.cdda.wav || echo "ERROR: cannot delete original file"
fi
cd -
