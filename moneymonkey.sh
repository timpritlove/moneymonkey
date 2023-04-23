#!/bin/sh
#
# Usage:
# 
# moneymonkey.sh command -o targetfile -f date -t date -l days -a account


# Primäre Konfigurationsvariable
#
# ACCOUNT     Name des MoneyMoney Bankkontos, dass exportiert werden soll (IBAN oder vergebener Name)
# TARGETFILE  Pfad der Exportdatei, die erstellt werden soll. Der Dateiname wird im Feld "Beleg" jeder Buchung mit abgelegt

ACCOUNT="${MONEYMONKEY_ACCOUNT}"
TARGETFILE="${MONEYMONKEY_TARGETFILE}"

# Grundeinstellung: Exportiere die Buchungen von gestern

YESTERDAY=$(date -v-1d +%Y-%m-%d)
FROM_DATE=${YESTERDAY}
TO_DATE=${YESTERDAY}


# Einlesen der Optionen

function usage {
  echo "./$(basename $0) export -o outfile -f from_date -t to_date -l days -a account"
  exit 1
}


function export_from_moneymoney {

  OPTSTRING="f:t:o:a:l:"

  while getopts ${OPTSTRING} arg; do
    case ${arg} in
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
        echo "$0: Diese Option benötigt einen Parameter -$OPTARG." >&2
        exit 1
        ;;
      ?)
        echo "Unbekannte Option: -${OPTARG}."
        usage
        exit 2
        ;;
    esac
  done


  # Überprüfen, ob eine Exportdatei angegeben wurde

  if [ -z "${TARGETFILE}" ]
  then
    echo "$0: Es wurde keine Exportdatei angegeben (verwende -o)"
    exit 1
  fi

  # Wurde kein Ende-Datum angegeben, exportiere nur einen Tag

  if [ -z "${TO_DATE}" ]
  then
    TO_DATE=${FROM_DATE}
  fi

  # Gesetzte Parameter anzeigen

  echo "Konto:       ${ACCOUNT}"
  echo "Von Datum:   ${FROM_DATE}"
  echo "Bis Datum:   ${TO_DATE}"
  echo "Exportdatei: ${TARGETFILE}"

  # Export in MoneyMoney durchführen lassen

  APPLESCRIPT='tell application "MoneyMoney" to set result to export transactions from account "'${ACCOUNT}'" from date "'${FROM_DATE}'" to date "'${TO_DATE}'" as "MoneyMonkey"'
  TMPFILE=$(osascript -e "${APPLESCRIPT}")

  # Verwende den Namen der Exportdatei als Belegnamen

  TMPFILENAME=`basename "${TMPFILE}"`
  TARGETFILENAME=`basename "${TARGETFILE}"`
  sed "s;${TMPFILENAME};${TARGETFILENAME};" ${TMPFILE} >"${TARGETFILE}"
  rm "${TMPFILE}"

  # Anzeigen der Exportdatei

  ls -l "${TARGETFILE}"
}

case "${1}" in
  export)
    shift
    export_from_moneymoney "$@"
    ;;
  *)
    echo "Unbekanntes Kommando: ${1}"
    usage
    exit 2
    ;;
esac

