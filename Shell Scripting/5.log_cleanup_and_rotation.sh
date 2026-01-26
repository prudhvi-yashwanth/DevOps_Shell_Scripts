#!/bin/bash

set -euo pipefail

LOG_DIR="/var/log/myapps"
ARCHIVE_DIR="/var/log/myapps/archive"
RETENTION_DAYS=7
LOG_EXTENSION="log"

TIMESTAMP=$(date '+%d-%m-%Y_%H-%M-%S')

# Exit quietly if log directory doesn't exist
[[ -d "$LOG_DIR" ]] || exit 0

# Ensure archive directory exists
mkdir -p "$ARCHIVE_DIR"

# Loop through all log files with the given extension
for LOG_FILE in "$LOG_DIR"/*.${LOG_EXTENSION}; do 
  [[ -f "$LOG_FILE" ]] || continue

# Extract just the filename (without path) and store it in BASENAME
  BASENAME=$(basename "$LOG_FILE")
  mv "$LOG_FILE" "$ARCHIVE_DIR/${BASENAME}_${TIMESTAMP}"
  gzip "$ARCHIVE_DIR/${BASENAME}_${TIMESTAMP}"
done 

# Delete archived files older than retention days
find "$ARCHIVE_DIR" -type f -name "*.gz" -mtime +$RETENTION_DAYS -delete

exit 0
