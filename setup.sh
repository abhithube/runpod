#!/bin/bash
set -e

if [ ! -d "/app/ComfyUI" ]; then
    echo "Setting up ComfyUI..."
    
    cd /app
    git clone https://github.com/comfyanonymous/ComfyUI
    cd ComfyUI
    
    python -m venv venv
    source venv/bin/activate
    
    pip install --upgrade pip
    pip install --no-cache-dir -r requirements.txt
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v1.0.0/nunchaku-1.0.0+torch2.9-cp312-cp312-linux_x86_64.whl
    
    cd custom_nodes
    git clone https://github.com/nunchaku-tech/ComfyUI-nunchaku
    
    for reqs in $(find . -name "requirements.txt"); do 
        pip install --no-cache-dir -r "$reqs"
    done
    
    cd /app/ComfyUI
    cp /app/extra_model_paths.yaml .
fi

cd /app/ComfyUI
source venv/bin/activate
exec python main.py --listen 0.0.0.0 --port 8188