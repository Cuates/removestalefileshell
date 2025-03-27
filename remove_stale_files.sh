#!/bin/sh
#
#        File: remove_stale_files.sh
#     Created: 07/25/2020
#     Updated: 03/27/2025
#  Programmer: Cuates
#  Updated By: AI Assistant
#     Purpose: Remove stale files 6 hours or greater
#

# Initialize array of possible directories to clean
directories="Directory01 Directory02"

# Log file path
LOG_FILE="/var/www/html/Doc_Directory/remove_stale_log.txt"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Loop through directories
for dir in $directories; do
  # Full path to the directory
  full_path="/var/www/html/Temp_Directory/$dir"

  # Check if directory exists
  if [ ! -d "$full_path" ]; then
    echo "[$(date +"%d-%m-%Y %H:%M:%S")] Directory $full_path does not exist." >> "$LOG_FILE"
    continue
  fi

  # Get current date/time for logging
  DATE=$(date +"%d-%m-%Y %H:%M:%S")

  # Check if directory is empty
  if [ ! "$(ls -A "$full_path" 2>/dev/null)" ]; then
    echo "[$DATE] $dir directory is empty." >> "$LOG_FILE"
    continue
  fi

  # Count files older than 6 hours (360 minutes)
  count=$(find "$full_path" -type f -mmin +360 | wc -l)

  # Check if there are no stale files to remove
  if [ "$count" -eq 0 ]; then
    echo "[$DATE] No files to remove from $dir directory." >> "$LOG_FILE"
  else
    # Remove stale files and log the action
    find "$full_path" -type f -mmin +360 -exec rm {} \;
    echo "[$DATE] Removed $count stale files from $dir directory." >> "$LOG_FILE"
  fi
done

exit 0
