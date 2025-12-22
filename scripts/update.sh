#!/bin/bash
set -e

ROOT_DIR=/workspace

PIP_CACHE_DIR=$ROOT_DIR/.cache/pip

COMFYUI_DIR=$ROOT_DIR/ComfyUI
NODES_DIR=$COMFYUI_DIR/custom_nodes

if [ -d $COMFYUI_DIR ]; then
  cd $COMFYUI_DIR

  echo "Updating ComfyUI..."
  git pull

  echo "Updating ComfyUI dependencies..."
  pip install -r requirements.txt
fi

for node_dir in $NODES_DIR/*/; do
  cd $node_dir

  node_nane=$(basename $node_dir)

  echo "Updating $node_nane..."
  git pull

  if [ -f $node_dir/requirements.txt ]; then
    echo "Updating $node_nane dependencies..."
    pip install -r requirements.txt
  fi
done