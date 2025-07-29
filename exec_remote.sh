#!/bin/bash
# Execute PowerShell commands on one or more remote hosts with JSON output
# Task UUID: b7ae2b8c-fb9a-4bf9-b871-4d97b7eddbcf / 4635180e-1e7e-4443-8f17-5056334d9597
set -euo pipefail

TARGETS=($1)
CMD="$2"

TMPDIR=$(mktemp -d)

for T in ${TARGETS[@]}; do
  (
    pwsh -File session_manager.ps1 -Target "$T"
    OUTPUT=$(ssh "$T" "powershell -NoProfile -Command \"$CMD | ConvertTo-Json -Depth 3\"" 2>&1)
    EC=$?
    printf '{"target":"%s","exitCode":%s,"stdout":"%s"}' "$T" "$EC" "${OUTPUT//$'\n'/ }" > "$TMPDIR/$T.json"
    if [ $EC -ne 0 ]; then
      sed -i 's/status: \[x\]/status: [u]/' agent_prio.md
      ./auto_diagnose.sh "$T" "$CMD" || true
    fi
  ) &
  PIDS+="$! "
done
wait $PIDS

FILES=($TMPDIR/*.json)
if [ ${#FILES[@]} -eq 1 ]; then
  cat "${FILES[0]}"
else
  echo '['
  FIRST=1
  for F in "${FILES[@]}"; do
    if [ $FIRST -eq 0 ]; then echo ','; fi
    cat "$F"
    FIRST=0
  done
  echo ']'
fi
rm -rf "$TMPDIR"
