#!/bin/bash
set -e

ROOT_DIR=/workspace
COMFYUI_DIR=$ROOT_DIR/ComfyUI

CUSTOM_NODES=(
  https://github.com/Comfy-Org/ComfyUI-Manager
  https://github.com/city96/ComfyUI-GGUF
)

cd $ROOT_DIR

if [ ! -d $COMFYUI_DIR ]; then
  echo "Installing ComfyUI..."
  git clone https://github.com/comfyanonymous/ComfyUI
else
  cd $COMFYUI_DIR

  echo "Updating ComfyUI..."
  git pull
fi

cd $COMFYUI_DIR

echo "Updating ComfyUI dependencies..."
pip install -r requirements.txt

for repo in ${CUSTOM_NODES[@]}; do
  repo_name=$(basename $repo)

  if [ ! -d $COMFYUI_DIR/custom_nodes/$repo_name ]; then
    cd $COMFYUI_DIR/custom_nodes

    echo "Installing $repo_name..."
    git clone $repo
  else
    cd $COMFYUI_DIR/custom_nodes/$repo_name

    echo "Updating $repo_name..."
    git pull
  fi

  if [ ! -d $COMFYUI_DIR/custom_nodes/$repo_name/requirements.txt ]; then
    cd $COMFYUI_DIR/custom_nodes/$repo_name

    echo "Updating $repo_name dependencies..."
    pip install -r requirements.txt
  fi
done

cd $COMFYUI_DIR

cat > extra_model_paths.yaml << 'EOF'
comfyui:
    base_path: /opt/comfyui/models/
    is_default: true
    checkpoints: checkpoints
    text_encoders: text_encoders
    clip_vision: clip_vision
    configs: configs
    controlnet: controlnet
    diffusion_models: |
      diffusion_models
      unet
    embeddings: embeddings
    loras: loras
    upscale_models: upscale_models
    vae: vae
    audio_encoders: audio_encoders
    model_patches: model_patches
EOF

echo "Starting ComfyUI server..."
python main.py --listen 0.0.0.0 --port 8188