#!/bin/bash
set -e

MODELS_DIR=/opt/comfyui/models

hf download Comfy-Org/z_image_turbo --local-dir . \
  split_files/diffusion_models/z_image_turbo_bf16.safetensors \
  split_files/text_encoders/qwen_3_4b.safetensors \
  split_files/vae/ae.safetensors

mkdir -p $MODELS_DIR/diffusion_models
mv split_files/diffusion_models/z_image_turbo_bf16.safetensors $MODELS_DIR/diffusion_models

mkdir -p $MODELS_DIR/text_encoders
mv split_files/text_encoders/qwen_3_4b.safetensors $MODELS_DIR/text_encoders

mkdir -p $MODELS_DIR/vae
mv split_files/vae/ae.safetensors $MODELS_DIR/vae

rm -r split_files