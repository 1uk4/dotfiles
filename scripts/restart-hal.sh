#!/bin/bash
# Restart OpenClaw gateway (run as hal-admin)
# Usage: ~/scripts/restart-hal.sh [status|start|stop|restart|logs]

SVC=openclaw.service

case "${1:-restart}" in
  status)
    sudo systemctl status "$SVC"
    ;;
  start)
    sudo systemctl start "$SVC"
    echo "Started."
    ;;
  stop)
    sudo systemctl stop "$SVC"
    echo "Stopped."
    ;;
  restart)
    sudo systemctl restart "$SVC"
    echo "Restarted."
    ;;
  logs)
    sudo journalctl -u "$SVC" -n "${2:-50}" -f
    ;;
  *)
    echo "Usage: $0 [status|start|stop|restart|logs]"
    exit 1
    ;;
esac
