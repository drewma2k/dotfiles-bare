#!/bin/bash
set -euo pipefail

# Office attendance tracker
# Prompts once per day if user is in the office and logs the response

# Display help message
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
  echo "Usage: office_tracker [OPTIONS]"
  echo ""
  echo "Prompts once per day for office attendance and logs the response."
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help message"
  echo "Log file: ~/.office_attendance.log"
  exit 0
fi

# Configuration
LOG_FILE="$HOME/.office_attendance.log"
LAST_RUN_FILE="$HOME/.office_tracker_last_run"

# Get current date (YYYY-MM-DD format)
CURRENT_DATE=$(date +%Y-%m-%d)

# Only run in interactive shells
if [[ ! -t 0 ]]; then
  exit 0
fi

# Check if script has already run today
if [ -f "$LAST_RUN_FILE" ]; then
  LAST_RUN_DATE=$(cat "$LAST_RUN_FILE")
  if [ "$LAST_RUN_DATE" = "$CURRENT_DATE" ]; then
    # Already run today, exit silently
    exit 0
  fi
fi

# Prompt user for office attendance
echo "Are you in the office today? (yes/no): "
read -r response

# Normalize response to lowercase
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

# Validate response
case "$response" in
  yes|y)
    answer="yes"
    ;;
  no|n)
    answer="no"
    ;;
  *)
    answer="invalid_response"
    ;;
esac

# Append to log file with timestamp
echo "$CURRENT_DATE,$answer" >> "$LOG_FILE"

# Update last run date
echo "$CURRENT_DATE" > "$LAST_RUN_FILE"

echo "Response logged. Thank you."
