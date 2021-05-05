#!/bin/bash
# hp f880x ドライブレコーダーの時差が稀によくバグって
# 時計がズレるので録画順にファイル名で並び直すツール
#                 Firmware version: f880x_V1.02.10_JP
PREFIX="CUST"
SEQ=0

if [ "$1" = "" ]; then
  echo "sort files by recorderd sequence for hp f880x"
  echo " Usage: $0 "
  exit
else
  DIR="$1"
fi

for FILE in `ls -1 "${DIR}" | sort -t '-' -k3`
do
  SEQ=`printf "%06d" ${SEQ}`
  mv -v "${FILE}" "${PREFIX}${SEQ}-${FILE}"
  SEQ=`expr "${SEQ}" + 1`
done
