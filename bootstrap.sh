#!/bin/bash
# Bootstrap Debian environment and install dependencies
# Task UUID: a16b76ee-14b4-4dbc-b351-9c13f35e6317
set -euo pipefail

# Install PowerShell
if ! command -v pwsh >/dev/null 2>&1; then
    echo "Installing PowerShell..."
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install -y powershell
fi

# Install Cloudflared
if ! command -v cloudflared >/dev/null 2>&1; then
    echo "Installing Cloudflared..."
    sudo apt-get update
    sudo apt-get install -y cloudflared
fi

# Install Git
if ! command -v git >/dev/null 2>&1; then
    echo "Installing Git..."
    sudo apt-get update
    sudo apt-get install -y git
fi

echo "Bootstrap complete"
