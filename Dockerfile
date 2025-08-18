FROM runpod/pytorch:0.7.0-ubuntu2404-cu1263-torch271

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
    git clone https://github.com/rgthree/rgthree-comfy && \
    git clone https://github.com/city96/ComfyUI-GGUF

# Install custom node dependencies
RUN for reqs in $(find . -name "requirements.txt"); do pip install -r "$reqs"; done

WORKDIR /workspace

# Copy model download script and entrypoint
COPY download_models.py /workspace/
COPY entrypoint.sh /workspace/
RUN chmod +x /workspace/entrypoint.sh

WORKDIR /workspace/ComfyUI

EXPOSE 8888

CMD ["/workspace/entrypoint.sh"]