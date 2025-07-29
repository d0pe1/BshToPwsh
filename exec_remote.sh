#!/bin/bash
# Execute a PowerShell command on the remote host and return JSON
# Task UUID: b7ae2b8c-fb9a-4bf9-b871-4d97b7eddbcf
set -euo pipefail

TARGET="$1"
COMMAND="$2"

pwsh -File session_manager.ps1 -Target "$TARGET"

OUTPUT=$(ssh "$TARGET" "powershell -NoProfile -Command \"$COMMAND | ConvertTo-Json -Depth 3\"" 2>&1)
EXIT_CODE=$?

cat <<JSON
{
  "exitCode": $EXIT_CODE,
  "stdout": "$OUTPUT"
}
JSON
