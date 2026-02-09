#!/usr/bin/with-contenv bash

# ==============================================================================
# Single Volume Persistence Strategy
# ==============================================================================
# Problem: User cannot attach a second volume for /config on Railway.
# Solution: Nest /config INSIDE the existing /data volume.
# 
# This script runs before Plex starts. It verifies if /config is ephemeral
# and redirects it to /data/.plex-config/ to ensure persistence.
# ==============================================================================

PERSISTENT_CONFIG_PATH="/data/.plex-config"

echo "[INFO] Checking persistence configuration..."

# Ensure the persistent directory exists inside the volume
if [ ! -d "$PERSISTENT_CONFIG_PATH" ]; then
    echo "[INFO] Creating persistent config directory at $PERSISTENT_CONFIG_PATH"
    mkdir -p "$PERSISTENT_CONFIG_PATH"
    chown -R plex:plex "$PERSISTENT_CONFIG_PATH"
fi

# Check if /config is already a symlink (our work is done)
if [ -L "/config" ]; then
    target=$(readlink -f /config)
    if [ "$target" == "$PERSISTENT_CONFIG_PATH" ]; then
        echo "[INFO] /config is already linked to persistent storage. All good."
        exit 0
    fi
fi

# Check if /config is a real directory (native ephemeral or volume)
if [ -d "/config" ] && [ ! -L "/config" ]; then
    echo "[WARN] /config is a standard directory. Migrating to single-volume strategy..."
    
    # Check if there is data to migrate (avoid overwriting if empty)
    if [ "$(ls -A /config)" ]; then
        echo "[INFO] Migrating existing ephemeral data to persistent volume..."
        cp -an /config/* "$PERSISTENT_CONFIG_PATH/"
    fi
    
    # Remove the ephemeral directory
    # Note: If /config was a mount point, this would fail. 
    # But strictly, if the user didn't mount a volume, it's just a folder in the container layer.
    rm -rf /config
    
    # Create the symlink
    echo "[INFO] Linking /config -> $PERSISTENT_CONFIG_PATH"
    ln -s "$PERSISTENT_CONFIG_PATH" /config
fi

# Final permission check
chown -R plex:plex "$PERSISTENT_CONFIG_PATH"
