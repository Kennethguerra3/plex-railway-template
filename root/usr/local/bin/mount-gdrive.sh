#!/bin/bash
set -e

echo "[Rclone] Starting Google Drive mount script..."

# Check if Rclone is enabled
if [ "${ENABLE_RCLONE}" != "true" ]; then
    echo "[Rclone] ENABLE_RCLONE is not set to 'true'. Skipping Google Drive mount."
    exit 0
fi

# Check if RCLONE_CONFIG is set
if [ -z "${RCLONE_CONFIG}" ]; then
    echo "[Rclone] ERROR: RCLONE_CONFIG environment variable is not set."
    echo "[Rclone] Please configure Rclone and set RCLONE_CONFIG in Railway."
    exit 1
fi

# Decode and write Rclone config
echo "[Rclone] Decoding Rclone configuration..."
mkdir -p /config/rclone
echo "${RCLONE_CONFIG}" | base64 -d > /config/rclone/rclone.conf

if [ ! -s /config/rclone/rclone.conf ]; then
    echo "[Rclone] ERROR: Failed to decode RCLONE_CONFIG. Please check the base64 encoding."
    exit 1
fi

# Set default values
RCLONE_REMOTE_NAME="${RCLONE_REMOTE_NAME:-gdrive}"
RCLONE_REMOTE_PATH="${RCLONE_REMOTE_PATH:-/}"

echo "[Rclone] Configuration:"
echo "  Remote Name: ${RCLONE_REMOTE_NAME}"
echo "  Remote Path: ${RCLONE_REMOTE_PATH}"
echo "  Mount Point: /mnt/gdrive"

# Create mount point if it doesn't exist
mkdir -p /mnt/gdrive

# Check if already mounted
if mountpoint -q /mnt/gdrive; then
    echo "[Rclone] /mnt/gdrive is already mounted. Unmounting first..."
    fusermount -u /mnt/gdrive || umount -l /mnt/gdrive || true
    sleep 2
fi

# Mount Google Drive with optimized settings for Plex
echo "[Rclone] Mounting Google Drive..."
rclone mount "${RCLONE_REMOTE_NAME}:${RCLONE_REMOTE_PATH}" /mnt/gdrive \
    --config /config/rclone/rclone.conf \
    --allow-other \
    --allow-non-empty \
    --vfs-cache-mode writes \
    --vfs-cache-max-age 24h \
    --vfs-cache-max-size 10G \
    --vfs-read-chunk-size 128M \
    --vfs-read-chunk-size-limit 2G \
    --buffer-size 256M \
    --dir-cache-time 24h \
    --poll-interval 15s \
    --umask 002 \
    --uid $(id -u plex) \
    --gid $(id -g plex) \
    --log-level INFO \
    --log-file /config/rclone/rclone.log \
    &

# Wait for mount to be ready
echo "[Rclone] Waiting for mount to be ready..."
for i in {1..30}; do
    if mountpoint -q /mnt/gdrive; then
        echo "[Rclone] ✓ Google Drive mounted successfully at /mnt/gdrive"
        echo "[Rclone] You can now add libraries in Plex pointing to /mnt/gdrive"
        exit 0
    fi
    sleep 1
done

echo "[Rclone] ERROR: Failed to mount Google Drive after 30 seconds"
echo "[Rclone] Check logs at /config/rclone/rclone.log for details"
exit 1
