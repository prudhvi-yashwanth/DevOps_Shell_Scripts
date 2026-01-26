#!/bin/bash

set -euo pipefail

# Directory containing application log files
LOG_DIR="/var/log/myapp"

# File where error report will be written
OUTPUT_FAIL="/var/log/error_report.log"

# Patterns to search for in log files
PATTERNS=("ERROR" "WARNING" "FATAL" "CRITICAL" "CAUTION" "INFO" "DANGER")

# Function to generate a timestamp in DD-MM-YYYY HH:MM:SS format
timestamp() {
  date '+%d-%m-%Y %H:%M:%S'
}

# Function to log a message with timestamp into the output file
log() {
  echo "$(timestamp): $1" >> "$OUTPUT_FAIL"
}

# Flag to track if any errors were found
FOUND_ERRORS=0

for LOG_FILE in "$LOG_DIR"/*.log; do
  # Skip if no log files exist
  [[ -f "$LOG_FILE" ]] || continue

  # Loop through each pattern and search inside the log file
  for PATTERN in "${PATTERNS[@]}"; do 
    if grep -q "$PATTERN" "$LOG_FILE"; then
      log "Found $PATTERN in $LOG_FILE"
      grep "$PATTERN" "$LOG_FILE" >> "$OUTPUT_FAIL"
      FOUND_ERRORS=1
    fi
  done
done


# Final check: exit with code 1 if errors were found, else 0
if (( FOUND_ERRORS == 1 )); then
  log "Log monitoring completed: ERROR FOUND"
  exit 1
else
  log "Log monitoring completed: no error found"
  exit 0 
fi

# cron usage example
# */10 * * * * /home/ubuntu/scripts/log_error_monitor.sh >> /var/log/cron_log_monitor.log 2>&1
