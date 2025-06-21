#!/bin/bash

INPUT_DIR="$1"
OUTPUT_DIR="$2"
FILTER_PROGRAM="./filter"

if [[ ! -d "$INPUT_DIR" || ! -x "$FILTER_PROGRAM" ]]; then
    echo "Nutzung: $0 <input-verzeichnis> <output-verzeichnis>" >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"
LOGFILE="$OUTPUT_DIR/processing.log"
> "$LOGFILE"

for file in "$INPUT_DIR"/*.csv; do
    base=$(basename "$file")
    output_file="$OUTPUT_DIR/filtered_$base"

    {
        echo "Verarbeite Datei: $file"
        cat "$file" | $FILTER_PROGRAM > "$output_file"
    } 2>>"$LOGFILE"
done

echo "Verarbeitung abgeschlossen. Siehe Logfile: $LOGFILE"
