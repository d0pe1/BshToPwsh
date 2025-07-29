#!/bin/bash
# Restart tunnels and sessions if disconnected
# Task UUID: b0dbc675-0b7a-4268-88f8-a96adcda65aa
set -euo pipefail

while true; do
    if ! pgrep -f "cloudflared tunnel" >/dev/null; then
        ./tunnel_setup.sh
    fi
    sleep 5
done
