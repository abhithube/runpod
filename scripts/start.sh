#!/bin/bash
set -e

ROOT_DIR=/workspace

COMFYUI_DIR=$ROOT_DIR/ComfyUI

cd $COMFYUI_DIR

echo "Starting ComfyUI server..."
python main.py --enable-manager --listen 0.0.0.0 --port 8188