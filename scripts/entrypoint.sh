#!/bin/bash
set -e

# Get user/group from environment or use defaults
PUID=${PUID:-911}
PGID=${PGID:-911}

# Create user and group if needed
groupadd -f -g $PGID parsechpr
id $PUID &>/dev/null || useradd -u $PUID -g $PGID parsechpr

# Ensure data directory exists and has correct ownership
mkdir -p "${HPR_DATA_DIR}"
chown -R $PUID:$PGID "${HPR_DATA_DIR}"

# First-time setup if binary doesn't exist
if [ ! -f "${HPR_DATA_DIR}/parsechpr" ]; then
    echo "HPR binary not found in ${HPR_DATA_DIR}, downloading..."
    /scripts/install-hpr.sh
    # Set permissions after download
    chown -R $PUID:$PGID "${HPR_DATA_DIR}"
fi

# Always create symlink to current binary
ln -sf "${HPR_DATA_DIR}/parsechpr" /bin/parsechpr

# Validate required environment variables
if [ -z "$TEAM_ID" ]; then
    echo "ERROR: TEAM_ID environment variable is required"
    exit 1
fi

if [ -z "$SECRET" ]; then
    echo "ERROR: SECRET environment variable is required"
    exit 1
fi

echo "Checking HPR binary locations:"
echo "Data dir contents:"
ls -la "${HPR_DATA_DIR}"
echo "Binary symlink:"
ls -la /bin/parsechpr
echo "Trying to run binary directly from data dir:"
ls -la "${HPR_DATA_DIR}/parsechpr"

# Run the relay directly
# Option 2: Using quotes around the variable name
exec env TEAM_ID="$TEAM_ID" /bin/parsechpr ${WAN_IP} ${PUBLIC_PORT} ${PRIVATE_PORT}