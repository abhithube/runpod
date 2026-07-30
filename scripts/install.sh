#!/bin/bash
set -e

ROOT_DIR=/workspace

COMFYUI_DIR=$ROOT_DIR/ComfyUI
NODES_DIR=$COMFYUI_DIR/custom_nodes
MODELS_DIR=$COMFYUI_DIR/models
EXTRA_MODELS_DIR=/opt/ComfyUI/models

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

  cat > extra_model_paths.yaml << EOF
comfyui:
    checkpoints: |
      $MODELS_DIR/checkpoints
      $EXTRA_MODELS_DIR/checkpoints
    text_encoders: $MODELS_DIR/text_encoders
    clip_vision: $MODELS_DIR/clip_vision
    configs: $MODELS_DIR/configs
    controlnet: $MODELS_DIR/controlnet
    diffusion_models: |
      $MODELS_DIR/diffusion_models
      $MODELS_DIR/unet
      $EXTRA_MODELS_DIR/diffusion_models
      $EXTRA_MODELS_DIR/unet
    embeddings: $MODELS_DIR/embeddings
    loras: |
      $MODELS_DIR/loras
      $EXTRA_MODELS_DIR/loras
    upscale_models: $MODELS_DIR/upscale_models
    vae: $MODELS_DIR/vae
    audio_encoders: $MODELS_DIR/audio_encoders
    model_patches: $MODELS_DIR/model_patches
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