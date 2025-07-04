FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y git

# Clone ComfyUI repo
RUN git clone https://github.com/comfyanonymous/ComfyUI

WORKDIR /workspace/ComfyUI

# Install ComfyUI dependencies
RUN pip install -r requirements.txt

WORKDIR /workspace/ComfyUI/custom_nodes

# Clone custom node repos
RUN git clone https://github.com/Comfy-Org/ComfyUI-Manager && \
    git clone https://github.com/city96/ComfyUI-GGUF

# Install custom node dependencies
RUN for reqs in $(find . -name "requirements.txt"); do pip install -r "$reqs"; done

WORKDIR /workspace/ComfyUI

EXPOSE 8888

CMD ["python", "main.py", "--listen", "--port", "8888"]