#!/bin/bash
# GitHub API wrapper — runs as hal-admin
# Usage: sudo -u hal-admin /home/hal-admin/scripts/github-api.sh <method> <endpoint> [data]

set -euo pipefail

TOKEN_FILE="/home/hal-admin/credentials/github-token.txt"

if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "ERROR: GitHub token not found" >&2
  exit 1
fi

TOKEN="$(cat "$TOKEN_FILE")"

METHOD="${1:?Usage: github-api.sh <GET|POST|PATCH|PUT|DELETE> <endpoint> [json-data]}"
ENDPOINT="${2:?Usage: github-api.sh <method> <endpoint> [json-data]}"
DATA="${3:-}"

BASE="https://api.github.com"

# Build curl command
CURL_ARGS=(
  -s
  -X "$METHOD"
  -H "Authorization: Bearer $TOKEN"
  -H "Accept: application/vnd.github+json"
  -H "X-GitHub-Api-Version: 2022-11-28"
)

if [[ -n "$DATA" ]]; then
  CURL_ARGS+=(-H "Content-Type: application/json" -d "$DATA")
fi

# Never output headers (may leak token in redirects)
curl "${CURL_ARGS[@]}" "${BASE}${ENDPOINT}"
