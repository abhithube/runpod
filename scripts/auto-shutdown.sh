#!/bin/bash
set -e

TIMEOUT_MINUTES=30
TIMEOUT_SECONDS=$((60 * TIMEOUT_MINUTES))
LAST_ACTIVITY_FILE=/tmp/last-activity

echo "Enabling inactivity timeout of $TIMEOUT_MINUTES minutes..."
touch $LAST_ACTIVITY_FILE

while true; do
    if command -v nvidia-smi &> /dev/null; then
        GPU_UTIL=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n1 | tr -d '[:space:]')
        
        if [ $GPU_UTIL -gt 5 ]; then
            echo "GPU active: $GPU_UTIL%. Resetting inactivity detection..."
            touch $LAST_ACTIVITY_FILE
        fi
    fi

    CURRENT_TIME=$(date +%s)
    LAST_ACTIVITY_TIME=$(stat -c %Y $LAST_ACTIVITY_FILE)
    INACTIVE_TIME=$((CURRENT_TIME - LAST_ACTIVITY_TIME))
    
    echo "Inactive for $INACTIVE_TIME seconds (threshold: $TIMEOUT_SECONDS)..."
    
    if [ $INACTIVE_TIME -ge $TIMEOUT_SECONDS ]; then
        echo "Inactive for $INACTIVE_TIME seconds. Stopping..."
        runpodctl stop pod $RUNPOD_POD_ID
    fi
    
    sleep 60
done