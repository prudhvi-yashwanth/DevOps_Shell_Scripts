#!/bin/bash

set -euo pipefail

SOURCE_DIR="/var/www/app"
BACKUP_DIR="/opt/backups"
RETENTION_DAYS=7

# Use safe timestamp format for filenames
TIMESTAMP=$(date '+%d-%m-%Y_%H-%M-%S')
BACKUP_FILE="app_backup_${TIMESTAMP}.tar.gz"
LOG_FILE="/var/log/backup_and_archive.log"

# Logging function
log() {
  echo "$(date '+%d-%m-%Y %H:%M:%S') : $1" >> "$LOG_FILE"
}

# Ensure source directory exists
[[ -d "$SOURCE_DIR" ]] || { log "ERROR: Source directory not found"; exit 1; }

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

log "Starting backup of $SOURCE_DIR"

# Create compressed backup
tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$SOURCE_DIR" .

log "Backup created: $BACKUP_DIR/$BACKUP_FILE"

# Cleanup old backups
log "Cleaning backups older than ${RETENTION_DAYS} days"
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -print -delete >> "$LOG_FILE" 2>&1

log "Backup cleanup completed"

exit 0
