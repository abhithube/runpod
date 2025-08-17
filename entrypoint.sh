#!/bin/bash

set -e

if [ -n "$B2_BUCKET_NAME" ] && [ -n "$COMFY_CONFIG" ]; then
    echo ">> Downloading models based on config..."
    python /workspace/download_models.py
else
    echo ">> Skipping model download."
fi

echo ">> Starting ComfyUI..."
exec python main.py --listen --port 8888