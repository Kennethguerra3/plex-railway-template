#!/bin/bash
set -e

echo "[Rclone] Starting Google Drive mount script..."

# Check if Rclone is enabled
if [ "${ENABLE_RCLONE}" != "true" ]; then
    echo "[Rclone] ENABLE_RCLONE is not set to 'true'. Skipping Google Drive mount."
    exit 0
fi

# Create config directory
mkdir -p /config/rclone

# Set default values
RCLONE_REMOTE_NAME="${RCLONE_REMOTE_NAME:-gdrive}"
RCLONE_REMOTE_PATH="${RCLONE_REMOTE_PATH:-/}"

# Detect authentication method
if [ -n "${RCLONE_SERVICE_ACCOUNT_JSON}" ]; then
    # Method 1: Service Account (Recommended - Simple)
    echo "[Rclone] Using Service Account authentication (recommended)"
    
    # Validate JSON
    if ! echo "${RCLONE_SERVICE_ACCOUNT_JSON}" | jq empty 2>/dev/null; then
        echo "[Rclone] ERROR: RCLONE_SERVICE_ACCOUNT_JSON is not valid JSON."
        echo "[Rclone] Please check the JSON file content."
        exit 1
    fi
    
    # Save Service Account JSON
    echo "${RCLONE_SERVICE_ACCOUNT_JSON}" > /config/rclone/service-account.json
    
    # Generate Rclone config automatically
    cat > /config/rclone/rclone.conf <<EOF
[${RCLONE_REMOTE_NAME}]
type = drive
scope = drive
service_account_file = /config/rclone/service-account.json
team_drive = 
EOF
    
    echo "[Rclone] ✓ Service Account configuration created"
    
elif [ -n "${RCLONE_CONFIG}" ]; then
    # Method 2: OAuth Personal (Advanced - Requires Rclone on PC)
    echo "[Rclone] Using OAuth personal authentication (advanced)"
    
    # Decode and write Rclone config
    echo "[Rclone] Decoding Rclone configuration..."
    echo "${RCLONE_CONFIG}" | base64 -d > /config/rclone/rclone.conf
    
    if [ ! -s /config/rclone/rclone.conf ]; then
        echo "[Rclone] ERROR: Failed to decode RCLONE_CONFIG. Please check the base64 encoding."
        exit 1
    fi
    
    echo "[Rclone] ✓ OAuth configuration decoded"
    
else
    # No authentication method provided
    echo "[Rclone] ERROR: No authentication method configured."
    echo "[Rclone] "
    echo "[Rclone] Please set ONE of the following:"
    echo "[Rclone] "
    echo "[Rclone] Option 1 (RECOMMENDED - Simple):"
    echo "[Rclone]   RCLONE_SERVICE_ACCOUNT_JSON = <your-service-account-json>"
    echo "[Rclone]   See SERVICE_ACCOUNT_SETUP.md for step-by-step guide"
    echo "[Rclone] "
    echo "[Rclone] Option 2 (Advanced):"
    echo "[Rclone]   RCLONE_CONFIG = <your-rclone-config-base64>"
    echo "[Rclone]   See GOOGLE_DRIVE_SETUP.md for instructions"
    exit 1
fi

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
        
        # Test read access
        if ls /mnt/gdrive > /dev/null 2>&1; then
            echo "[Rclone] ✓ Read access verified"
        else
            echo "[Rclone] WARNING: Mount successful but cannot read files"
            echo "[Rclone] If using Service Account, make sure you shared the folder with:"
            if [ -f /config/rclone/service-account.json ]; then
                SERVICE_EMAIL=$(jq -r '.client_email' /config/rclone/service-account.json)
                echo "[Rclone]   ${SERVICE_EMAIL}"
            fi
        fi
        
        exit 0
    fi
    sleep 1
done

echo "[Rclone] ERROR: Failed to mount Google Drive after 30 seconds"
echo "[Rclone] Check logs at /config/rclone/rclone.log for details"
exit 1
