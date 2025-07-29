#!/bin/bash
# Clone and register agent_suite utility repository
# Task UUID: 5312e7de-316d-4424-8d35-a5b1a10fe0d5
set -euo pipefail

REPO_URL=${AGENT_SUITE_REPO_URL:-https://example.com/agent_suite.git}
TARGET_DIR=${AGENT_SUITE_DIR:-$HOME/agent_suite}

if [ ! -d "$TARGET_DIR/.git" ]; then
    git clone "$REPO_URL" "$TARGET_DIR"
else
    echo "agent_suite already cloned"
fi

echo "Agent suite available at $TARGET_DIR"
