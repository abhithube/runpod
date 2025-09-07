#!/bin/bash

CUSTOM_NODES=(
  "https://github.com/rgthree/rgthree-comfy"
  "https://github.com/city96/ComfyUI-GGUF"
  "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
)

cd /workspace
if [ -d "ComfyUI" ]; then
    cd /workspace/ComfyUI
    git pull
else
    git clone https://github.com/comfyanonymous/ComfyUI.git
    cd /workspace/ComfyUI
fi

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python -m venv venv
fi

echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing ComfyUI dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo "Installing custom dependencies..."
pip install huggingface_hub[cli]

echo "Installing/updating custom nodes..."
cd /workspace/ComfyUI/custom_nodes
for node_url in "${CUSTOM_NODES[@]}"; do
    node_name=$(basename "$node_url")
    echo "Processing $node_name..."
    
    if [ -d "$node_name" ]; then
        cd "/workspace/ComfyUI/custom_nodes/$node_name"
        git pull
    else
        git clone "$node_url"
        cd "/workspace/ComfyUI/custom_nodes/$node_name"
    fi
    
    if [ -f "requirements.txt" ]; then
        echo "Installing dependencies for $node_name..."
        pip install -r requirements.txt
    fi
done

echo "Syncing ComfyUI to container..."
rsync -av --exclude='venv/' /workspace/ComfyUI/ /ComfyUI/

echo "Copying model paths config to the container..."
cp /workspace/extra_model_paths.yaml /ComfyUI/

echo "Starting ComfyUI..."
cd /ComfyUI
source /workspace/ComfyUI/venv/bin/activate
python main.py --listen 0.0.0.0 --port 3000