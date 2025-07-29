#!/bin/bash
# Attempt automatic recovery on failure
# Task UUID: 63675cf5-30d6-4891-a12a-61042475ad85 / 70206be2-c6ee-4ef7-bfbd-31e322524e64
set -euo pipefail

TARGET="$1"
CMD="$2"

for i in {1..3}; do
  ./tunnel_setup.sh || true
  pwsh -File session_manager.ps1 -Target "$TARGET" || true
  RESULT=$(ssh "$TARGET" "powershell -NoProfile -Command \"$CMD | ConvertTo-Json -Depth 3\"" 2>&1)
  EC=$?
  if [ $EC -eq 0 ]; then
    echo "$RESULT"
    exit 0
  fi
  sleep 1
done
printf 'Recovery failed after 3 attempts\n' >&2
exit 1
