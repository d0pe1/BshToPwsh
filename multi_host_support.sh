#!/bin/bash
# Manage multiple host sessions via tag
# Task UUID: 24c69a60-b31e-4dd8-848b-d5415138e6f4 / 99fc3a91-d367-4e0a-8362-526b080f1d5f
set -euo pipefail

case "$1" in
  add)
    echo "$2=$3" >> hosts.db
    ;;
  list)
    cat hosts.db
    ;;
  *)
    echo "Usage: $0 add <tag> <host>|list" >&2
    exit 1
    ;;
esac
