#!/bin/bash
# Check if env vars are set without revealing values
# Usage: sudo -u hal-admin /home/hal-admin/scripts/check-env.sh <var-name> [var-name...]

set -euo pipefail

ENV_FILE="/home/hal-admin/credentials/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: .env file not found" >&2
  exit 1
fi

for VAR in "$@"; do
  # Only allow alphanumeric + underscore in var names (prevent injection)
  if [[ ! "$VAR" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    echo "INVALID: $VAR" >&2
    continue
  fi
  if grep -q "^${VAR}=" "$ENV_FILE"; then
    VALUE=$(grep "^${VAR}=" "$ENV_FILE" | cut -d'=' -f2-)
    if [[ -n "$VALUE" ]]; then
      echo "$VAR=SET (${#VALUE} chars)"
    else
      echo "$VAR=EMPTY"
    fi
  else
    echo "$VAR=UNSET"
  fi
done
