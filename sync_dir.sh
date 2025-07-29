#!/bin/bash
# Rsync-style directory mirroring over the PowerShell session
# Task UUID: 0741a646-e5bf-4b9f-a326-a1b4a536a651
set -euo pipefail

TARGET="$1"
LOCAL_DIR="$2"
REMOTE_DIR="$3"

rsync -avz "$LOCAL_DIR/" "$TARGET:$REMOTE_DIR/"
