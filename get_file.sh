#!/bin/bash
# Retrieve a file from the Windows host
# Task UUID: 66d30233-56ef-4cf5-b355-0c286db5d9a3
set -euo pipefail

TARGET="$1"
REMOTE_PATH="$2"
LOCAL_DEST="$3"

ssh "$TARGET" "base64 -w0 \"$REMOTE_PATH\"" | base64 -d > "$LOCAL_DEST"
