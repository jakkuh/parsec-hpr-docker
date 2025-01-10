#!/bin/bash
set -e

# Install dependencies
apt-get update
apt-get install -y wget systemd gnupg
rm -rf /var/lib/apt/lists/*

# Import Parsec GPG key
curl -s https://builds.parsec.app/hpr/gpg/parsechpr_public.key | gpg --import

# Set up directories
mkdir -p /etc/systemd/system
mkdir -p /app
cd /app

# Install HPR binary
/scripts/install-hpr.sh

# Cleanup
apt-get clean
rm -rf /var/lib/apt/lists/*