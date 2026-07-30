#!/bin/bash
set -e

MODELS_DIR=/opt/comfyui/models

uvx hf download --local-dir . Comfy-Org/Krea-2 \
  diffusion_models/krea2_turbo_fp8_scaled.safetensors \
  text_encoders/qwen3vl_4b_fp8_scaled.safetensors \
  vae/qwen_image_vae.safetensors

mkdir -p $MODELS_DIR/diffusion_models
mv diffusion_models/krea2_turbo_fp8_scaled.safetensors $MODELS_DIR/diffusion_models

mkdir -p $MODELS_DIR/text_encoders
mv text_encoders/qwen3vl_4b_fp8_scaled.safetensors $MODELS_DIR/text_encoders

mkdir -p $MODELS_DIR/vae
mv vae/qwen_image_vae.safetensors $MODELS_DIR/vae

rm -r diffusion_models text_encoders vae