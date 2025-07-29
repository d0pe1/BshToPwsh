#!/bin/bash
# Restart tunnels and REST API if disconnected and send session heartbeats
# Task UUID: b0dbc675-0b7a-4268-88f8-a96adcda65aa / 6a6fe28d-00cd-462d-a4df-8facf46c2467
set -euo pipefail

API_PID_FILE="agent_api.pid"

function start_api {
    if [ ! -f "$API_PID_FILE" ] || ! kill -0 $(cat "$API_PID_FILE") 2>/dev/null; then
        nohup python3 agent_exec.py >/dev/null 2>&1 & echo $! > "$API_PID_FILE"
    fi
}

while true; do
    if ! pgrep -f "cloudflared tunnel" >/dev/null; then
        ./tunnel_setup.sh
    fi
    start_api
    for sess in $HOME/.config/bsh2pwsh/*.session; do
        [ -e "$sess" ] || continue
        target=$(basename "$sess" .session)
        pwsh -File session_manager.ps1 -Target "$target" >/dev/null 2>&1 || true
    done
    sleep 60
done
