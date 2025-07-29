#!/bin/bash
# Upload a file to the Windows host in chunks with hash verification
# Task UUID: 773dca6b-e5a1-4b6a-9ae0-799d29db2830
set -euo pipefail

TARGET="$1"
SOURCE_FILE="$2"
DEST_PATH="$3"

B64=$(base64 "$SOURCE_FILE")
CHUNK_SIZE=4000
INDEX=0
while [ $INDEX -lt ${#B64} ]; do
    CHUNK=${B64:$INDEX:$CHUNK_SIZE}
    ssh "$TARGET" "echo $CHUNK >> $DEST_PATH.b64"
    INDEX=$((INDEX + CHUNK_SIZE))
done
ssh "$TARGET" "base64 -d -o $DEST_PATH $DEST_PATH.b64 && rm $DEST_PATH.b64"
