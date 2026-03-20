#!/bin/bash
# Google Calendar wrapper — runs as hal-admin
# Usage: sudo -u hal-admin /home/hal-admin/scripts/gcal.sh <command> [args...]

set -euo pipefail

CREDS="/home/hal-admin/credentials/calendar-service-account.json"
SCRIPT_DIR="$(dirname "$0")"

# Validate credentials exist
if [[ ! -f "$CREDS" ]]; then
  echo "ERROR: Credentials file not found" >&2
  exit 1
fi

CMD="${1:-help}"
shift || true

case "$CMD" in
  list-events)
    # Args: [date] [end-date]
    DATE="${1:-$(date +%Y-%m-%d)}"
    node "$SCRIPT_DIR/gcal-helper.js" list "$CREDS" "$DATE" "${2:-}"
    ;;
  add-event)
    # Args: <title> <start> <end> [description]
    if [[ $# -lt 3 ]]; then
      echo "Usage: gcal.sh add-event <title> <start-iso> <end-iso> [description]" >&2
      exit 1
    fi
    node "$SCRIPT_DIR/gcal-helper.js" add "$CREDS" "$1" "$2" "$3" "${4:-}"
    ;;
  delete-event)
    # Args: <event-id>
    if [[ $# -lt 1 ]]; then
      echo "Usage: gcal.sh delete-event <event-id>" >&2
      exit 1
    fi
    node "$SCRIPT_DIR/gcal-helper.js" delete "$CREDS" "$1"
    ;;
  update-event)
    # Args: <event-id> <field> <value>
    if [[ $# -lt 3 ]]; then
      echo "Usage: gcal.sh update-event <event-id> <field> <value>" >&2
      exit 1
    fi
    node "$SCRIPT_DIR/gcal-helper.js" update "$CREDS" "$1" "$2" "$3"
    ;;
  move-event)
    # Args: <event-id> <new-start> <new-end>
    if [[ $# -lt 3 ]]; then
      echo "Usage: gcal.sh move-event <event-id> <new-start-iso> <new-end-iso>" >&2
      exit 1
    fi
    node "$SCRIPT_DIR/gcal-helper.js" move "$CREDS" "$1" "$2" "$3"
    ;;
  help)
    echo "Commands: list-events [date] [end-date], add-event <title> <start> <end> [desc], delete-event <id>, update-event <id> <field> <value>, move-event <id> <start> <end>"
    ;;
  *)
    echo "Unknown command: $CMD" >&2
    exit 1
    ;;
esac
