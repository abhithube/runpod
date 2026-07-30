#!/bin/bash
set -e

ROOT_DIR=/workspace

COMFYUI_DIR=$ROOT_DIR/ComfyUI
MODELS_DIR=$COMFYUI_DIR/models

cd $ROOT_DIR

uvx hf download --local-dir . Comfy-Org/z_image_turbo \
  split_files/diffusion_models/z_image_turbo_int8_convrot.safetensors \
  split_files/text_encoders/qwen_3_4b_fp8_mixed.safetensors \
  split_files/vae/ae.safetensors

mkdir -p $MODELS_DIR/diffusion_models
mv split_files/diffusion_models/z_image_turbo_int8_convrot.safetensors $MODELS_DIR/diffusion_models

mkdir -p $MODELS_DIR/text_encoders
mv split_files/text_encoders/qwen_3_4b_fp8_mixed.safetensors $MODELS_DIR/text_encoders

mkdir -p $MODELS_DIR/vae
mv split_files/vae/ae.safetensors $MODELS_DIR/vae

rm -r split_files