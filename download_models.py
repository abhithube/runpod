#!/usr/bin/env python3
"""
Model download script for ComfyUI Runpod sessions.
Downloads models based on config files stored in Backblaze.
"""

import json
import os
import subprocess
import sys
from pathlib import Path


def run_command(cmd, check=True):
    """Run a shell command and return the result."""
    print(f">> Running: {cmd}")
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if check and result.returncode != 0:
        print(f"Error running command: {cmd}")
        print(f"stdout: {result.stdout}")
        print(f"stderr: {result.stderr}")
        sys.exit(1)
    return result


def download_config_file(bucket_name, config_name):
    """Download config file from Backblaze."""
    config_path = f"/tmp/{config_name}.json"
    remote_path = f"b2:{bucket_name}/configs/{config_name}.json"
    
    print(f">> Downloading config: {remote_path}")
    cmd = f"rclone copy {remote_path} /tmp/"
    result = run_command(cmd, check=False)
    
    if result.returncode != 0:
        print(f"Failed to download config file: {config_name}.json")
        print("Available configs:")
        list_cmd = f"rclone lsf b2:{bucket_name}/configs/"
        list_result = run_command(list_cmd, check=False)
        if list_result.returncode == 0:
            print(list_result.stdout)
        else:
            print("Could not list available configs")
        sys.exit(1)
    
    return config_path


def download_models(bucket_name, models_list):
    """Download specified models from Backblaze."""
    base_remote = f"b2:{bucket_name}/ComfyUI/models"
    base_local = "/workspace/ComfyUI/models"
    
    # Ensure local directories exist
    Path(base_local).mkdir(parents=True, exist_ok=True)
    
    for model_info in models_list:
        if isinstance(model_info, str):
            # Simple string path
            model_path = model_info
        elif isinstance(model_info, dict):
            # Dictionary with path and optional settings
            model_path = model_info.get("path", "")
            if not model_path:
                print(f"Warning: Model entry missing 'path': {model_info}")
                continue
        else:
            print(f"Warning: Invalid model entry: {model_info}")
            continue
        
        # Determine local and remote paths
        remote_file = f"{base_remote}/{model_path}"
        local_file = f"{base_local}/{model_path}"
        local_dir = os.path.dirname(local_file)
        
        # Create local directory if it doesn't exist
        Path(local_dir).mkdir(parents=True, exist_ok=True)
        
        # Skip if file already exists
        if os.path.exists(local_file):
            print(f">> Skipping (already exists): {model_path}")
            continue
        
        print(f">> Downloading: {model_path}")
        cmd = f"rclone copy '{remote_file}' '{local_dir}/'"
        run_command(cmd)


def main():
    """Main function."""
    bucket_name = os.getenv("B2_BUCKET_NAME")
    if not bucket_name:
        print("Error: B2_BUCKET_NAME environment variable not set")
        sys.exit(1)
    
    config_name = os.getenv("COMFY_CONFIG")
    if not config_name:
        print("Error: COMFY_CONFIG environment variable not set")
        sys.exit(1)
    print(f">> Using config: {config_name}")
    
    # Download and parse config file
    config_path = download_config_file(bucket_name, config_name)
    
    try:
        with open(config_path, 'r') as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error parsing config file: {e}")
        sys.exit(1)
    
    # Validate config structure
    if not isinstance(config, dict):
        print("Error: Config file must be a JSON object")
        sys.exit(1)
    
    if "models" not in config:
        print("Error: Config file must contain a 'models' key")
        sys.exit(1)
    
    models = config["models"]
    if not isinstance(models, list):
        print("Error: 'models' must be a list")
        sys.exit(1)
    
    print(f">> Found {len(models)} models to download")
    
    # Download models
    download_models(bucket_name, models)
    
    print(">> Model download complete!")


if __name__ == "__main__":
    main()