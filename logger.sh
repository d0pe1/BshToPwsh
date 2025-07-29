#!/bin/bash
# Log job status with timestamps
# Task UUID: 120f8edd-4a1a-4d60-a3c0-a0faa48c5de2
set -euo pipefail

MESSAGE="$1"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%MZ)
echo "$TIMESTAMP $MESSAGE" >> logs/jobs.log
