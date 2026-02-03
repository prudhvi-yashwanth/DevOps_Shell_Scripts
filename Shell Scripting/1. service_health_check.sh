#!/bin/bash
set -euo pipefail

SERVICES_LIST=("httpd" "nginx" "mysql" "postgresql")
LOG_FILE_LOCATE="/var/log/service_health.log"

touch "$LOG_FILE_LOCATE" 2>/dev/null || { echo "Cannot write to $LOG_FILE_LOCATE. Run with sudo?"; exit 1; }

calculate_timestamp() {
  date "+%d-%m-%Y %H:%M:%S"
}

writing_log() {
  local message="$1"
  printf "%s : %s\n" "$(calculate_timestamp)"  "$message" >> "$LOG_FILE_LOCATE"
}


check_service_status() {
  local SERVICE_NAME="$1"

  writing_log "Service Checking started for $SERVICE_NAME"

  if systemctl is-active --quiet "$SERVICE_NAME"; then
    writing_log "Service $SERVICE_NAME is running"
  else 
    writing_log "Service $SERVICE_NAME not running. Restarting..."

    if systemctl restart "$SERVICE_NAME"; then
      if systemctl is-active --quiet "$SERVICE_NAME"; then 
        writing_log " Service $SERVICE_NAME restarted successfully"
      else
        writing_log "Error: Service $SERVICE_NAME restart attempted but still inactive"
        return 1 
      fi 
    else
      writing_log "Error: Failed to restart $SERVICE_NAME"
      return 1 
    fi
  fi
}

FAILURES=0
for SERVICE in "${SERVICES_LIST[@]}"; do
  if ! check_service_status "$SERVICE"; then
    FAILURES=$((FAILURES + 1))
  fi
done


if [[ "$FAILURES" -gt 0 ]]; then
  writing_log "Service health check completed with $FAILURES failure(s)"
  exit 1
else
  writing_log "Service health check completed successfully"
  exit 0
fi



