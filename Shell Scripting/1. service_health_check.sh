#!/bin/bash

set -euo pipefail

SERVICES=("nginx" "httpd" "mysql" "postgresql")
LOG_FILE="/var/log/service_health_check.log"

timestamp() {
  date '+%d-%m-%Y %H:%M:%S'
}

log() {
  local MESSAGE="$1"
  echo "$(timestamp) : $MESSAGE" >> "$LOG_FILE"
}

check_service() {
  local SERVICE_NAME="$1"

  log "Checking service status: $SERVICE_NAME"

  if systemctl is-active --quiet "$SERVICE_NAME"; then
    log "Service $SERVICE_NAME is running"
  else
    log "Service $SERVICE_NAME is NOT running. Restarting..."

    if systemctl restart "$SERVICE_NAME"; then
      if systemctl is-active --quiet "$SERVICE_NAME"; then
        log "Service $SERVICE_NAME restarted successfully"
      else
        log "ERROR: Service $SERVICE_NAME restart attempted but still inactive"
        return 1
      fi
    else
      log "ERROR: Failed to execute restart for $SERVICE_NAME"
      return 1
    fi
  fi
}

FAILURES=0

for SERVICE in "${SERVICES[@]}"; do
  if ! check_service "$SERVICE"; then
    FAILURES=$((FAILURES + 1))
  fi
done

if [ "$FAILURES" -gt 0 ]; then
  log "Service health check completed with $FAILURES failure(s)"
  exit 1
else
  log "Service health check completed successfully"
  exit 0
fi
