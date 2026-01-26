#!/bin/bash

set -euo pipefail

# Threshold percentage for warning
THRESHOLD=80

# Log file
LOG_FILE="/var/log/disk_usage_monitor.log"

# Filesystems to monitor (add more paths as needed)
FILESYSTEMS=("/" "/home" "/var")

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log() {
  local MESSAGE="$1"
  echo "$(timestamp) : $MESSAGE" >> "$LOG_FILE"
}

# Function to get disk usage for a given mount point
get_disk_usage() {
  local MOUNT_POINT="$1"
  df -P "$MOUNT_POINT" | tail -1 | awk '{print $5}' | tr -d '%'
}

# Function to check usage against threshold
check_usage() {
  local MOUNT_POINT="$1"
  local USAGE
  USAGE=$(get_disk_usage "$MOUNT_POINT")

  log "Current disk usage on $MOUNT_POINT: ${USAGE}%"

  if (( USAGE >= THRESHOLD )); then
    log "WARNING: Disk usage on $MOUNT_POINT exceeded threshold ${THRESHOLD}%"
    return 1
  else
    log "Disk usage on $MOUNT_POINT is within safe limits"
    return 0
  fi
}

# Loop through all filesystems
EXIT_CODE=0
for FS in "${FILESYSTEMS[@]}"; do
  if ! check_usage "$FS"; then
    EXIT_CODE=1
  fi
done

exit "$EXIT_CODE"
