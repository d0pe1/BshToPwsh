#!/bin/bash
# Expose simple health check
# Task UUID: 60efded1-8ac7-4b1f-88df-a61b590bcbd0
set -euo pipefail

if pgrep -f "cloudflared tunnel" >/dev/null; then
    echo "tunnel: ok"
else
    echo "tunnel: down"
fi
