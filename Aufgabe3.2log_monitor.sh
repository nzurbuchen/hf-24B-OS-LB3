#!/bin/bash

LOG_FILES=("$@")
EXPORT_FILE="filtered_export.log"
TMP_FIFO="/tmp/log_monitor_fifo_$$"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

filter="ALL"

# Menü zur Filterauswahl
select_filter() {
    echo "Filteroption auswählen:"
    echo "1) Alle Meldungen"
    echo "2) Nur ERROR"
    echo "3) Nur WARNING"
    echo "4) Nur INFO"
    echo "5) Exportieren und Beenden"
    read -rp "Auswahl: " choice

    case $choice in
        1) filter="ALL" ;;
        2) filter="ERROR" ;;
        3) filter="WARNING" ;;
        4) filter="INFO" ;;
        5) echo "Exportiere nach $EXPORT_FILE..."; cp "$TMP_FIFO" "$EXPORT_FILE"; exit 0 ;;
        *) echo "Ungültige Auswahl";;
    esac
}

# Echtzeitüberwachung starten
start_monitoring() {
    mkfifo "$TMP_FIFO"

    # tail -F für alle Logdateien parallel
    tail -F "${LOG_FILES[@]}" > "$TMP_FIFO" &
    TAIL_PID=$!

    trap "kill $TAIL_PID; rm -f $TMP_FIFO; exit" INT TERM

    while true; do
        select_filter
        echo "Monitoring läuft... (STRG+C zum Abbrechen)"

        while read -r line < "$TMP_FIFO"; do
            case "$line" in
                *ERROR*)
                    [[ $filter == "ALL" || $filter == "ERROR" ]] && echo -e "${RED}${line}${NC}" ;;
                *WARNING*)
                    [[ $filter == "ALL" || $filter == "WARNING" ]] && echo -e "${YELLOW}${line}${NC}" ;;
                *INFO*)
                    [[ $filter == "ALL" || $filter == "INFO" ]] && echo -e "${GREEN}${line}${NC}" ;;
                *)
                    [[ $filter == "ALL" ]] && echo "$line" ;;
            esac
        done
    done
}

start_monitoring
