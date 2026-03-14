#!/bin/bash
# Restart OpenClaw gateway (run as hal-admin)
# Usage: ~/scripts/restart-hal.sh [status|start|stop|restart|logs]

HAL_UID=$(id -u hal)
CMD="sudo -u hal XDG_RUNTIME_DIR=/run/user/$HAL_UID systemctl --user"

case "${1:-restart}" in
  status)
    $CMD status openclaw-gateway
    ;;
  start)
    $CMD start openclaw-gateway
    echo "Started."
    ;;
  stop)
    $CMD stop openclaw-gateway
    echo "Stopped."
    ;;
  restart)
    $CMD restart openclaw-gateway
    echo "Restarted."
    ;;
  logs)
    sudo -u hal XDG_RUNTIME_DIR=/run/user/$HAL_UID journalctl --user -u openclaw-gateway -n "${2:-50}" -f
    ;;
  *)
    echo "Usage: $0 [status|start|stop|restart|logs]"
    exit 1
    ;;
esac
