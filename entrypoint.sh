#!/bin/bash

set -e

if [ -n "$B2_BUCKET_NAME" ]; then
    echo ">> Found B2 configuration. Downloading models based on config..."
    python /workspace/download_models.py
else
    echo ">> B2_BUCKET_NAME not set. Skipping model download."
fi

echo ">> Starting ComfyUI..."
exec python main.py --listen --port 8888