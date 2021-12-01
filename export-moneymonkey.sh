#!/bin/bash
#
# Usage:
# 
# export-moneymonkey.sh -o targetfile -f date -t date -l days -a account

ACCOUNT="${MONEYMONKEY_ACCOUNT}"
TARGETFILE="${MONEYMONKEY_TARGETFILE}"

function usage {
        echo "./$(basename $0) -h --> shows usage"
        echo "./$(basename $0) -o outfile -f from_date -t to_date -l days -a account"
	exit 1
}

OPTSTRING=":hf:t:o:a:l:"

YESTERDAY=$(date -v-1d +%Y-%m-%d)
FROM_DATE=${YESTERDAY}
TO_DATE=${YESTERDAY}

while getopts ${OPTSTRING} arg; do
  case ${arg} in
    h)
      usage
      ;;
    a)
      ACCOUNT="${OPTARG}"
      ;;
    o)
      TARGETFILE="${OPTARG}"
      ;;
    f)
      FROM_DATE="${OPTARG}"
      ;;
    t)
      TO_DATE="${OPTARG}"
      ;;
    l)
      TO_DATE="${YESTERDAY}"
      FROM_DATE=$(date -v-${OPTARG}d +%Y-%m-%d)
      ;;
    :)
      echo "$0: Must supply an argument to -$OPTARG." >&2
      exit 1
      ;;
	?)
	echo "Invalid option: -${OPTARG}."
	usage
	exit 2
      ;;
  esac
done

if [ -z "${TARGETFILE}" ]
then
  echo "$0: Target file not specified (use -o)"
  exit 1
fi



if [ -z "${TO_DATE}" ]
then
	TO_DATE=${FROM_DATE}
fi

echo "ACCOUNT: ${ACCOUNT}"
echo "FROM_DATE: ${FROM_DATE}"
echo "TO_DATE: ${TO_DATE}"
echo "TARGETFILE: ${TARGETFILE}"

# Export in MoneyMoney durchführen lassen

APPLESCRIPT='tell application "MoneyMoney" to set result to export transactions from account "'${ACCOUNT}'" from date "'${FROM_DATE}'" to date "'${TO_DATE}'" as "MoneyMonkey"'
echo "Exporting ${FROM_DATE}/${TO_DATE}"
TMPFILE=$(osascript -e "${APPLESCRIPT}")

# Ersetze Belegnamen durch Zieldateinamen

TMPFILENAME=`basename "${TMPFILE}"`
TARGETFILENAME=`basename "${TARGETFILE}"`
sed "s;${TMPFILENAME};${TARGETFILENAME};" ${TMPFILE} >"${TARGETFILE}"
rm "${TMPFILE}"
ls -l "${TARGETFILE}"
