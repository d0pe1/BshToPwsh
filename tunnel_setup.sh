#!/bin/bash
# Configure Cloudflare tunnels
# Task UUID: 7cec4d60-20eb-4099-aa9d-0d673def22a5
set -euo pipefail

TUNNEL_NAME=${TUNNEL_NAME:-bsh_to_pwsh}
CLOUDFLARED=${CLOUDFLARED_BIN:-cloudflared}
CREDENTIALS_FILE=${CLOUDFLARE_CRED:-/etc/cloudflared/credentials.json}

$CLOUDFLARED tunnel --cred-file "$CREDENTIALS_FILE" run "$TUNNEL_NAME" &

sleep 2
if pgrep -f "${CLOUDFLARED} tunnel" > /dev/null; then
    echo "Cloudflare tunnel running"
else
    echo "Failed to start Cloudflare tunnel" >&2
    exit 1
fi
