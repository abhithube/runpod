#!/bin/bash
set -e

ROOT_DIR=/workspace

COMFYUI_DIR=$ROOT_DIR/ComfyUI
NODES_DIR=$COMFYUI_DIR/custom_nodes

CUSTOM_NODES=(
  https://github.com/rgthree/rgthree-comfy
)

if [ ! -d $COMFYUI_DIR ]; then
  cd $ROOT_DIR

  echo "Installing ComfyUI..."
  git clone https://github.com/comfyanonymous/ComfyUI

  cd $COMFYUI_DIR

  echo "Installing ComfyUI dependencies..."
  pip install -r requirements.txt

  echo "Installing ComfyUI-Manager dependencies..."
  pip install -r manager_requirements.txt

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
fi

for repo in ${CUSTOM_NODES[@]}; do
  node_name=$(basename $repo)
  node_dir=$NODES_DIR/$node_name

  if [ ! -d $node_dir ]; then
    cd $NODES_DIR

    echo "Installing $node_name..."
    git clone $repo

    if [ -f $node_dir/requirements.txt ]; then
      cd $node_dir

      echo "Installing $node_name dependencies..."
      pip install -r requirements.txt
    fi
  fi
done