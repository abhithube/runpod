FROM runpod/pytorch:0.7.0-ubuntu2404-cu1263-torch271

# Clone ComfyUI repo
RUN git clone https://github.com/comfyanonymous/ComfyUI

WORKDIR /ComfyUI

# Install ComfyUI dependencies
RUN pip install -r requirements.txt

WORKDIR /ComfyUI/custom_nodes

# Clone custom node repos
RUN git clone https://github.com/Comfy-Org/ComfyUI-Manager && \
    git clone https://github.com/rgthree/rgthree-comfy && \
    git clone https://github.com/city96/ComfyUI-GGUF

# Install custom node dependencies
RUN for reqs in $(find . -name "requirements.txt"); do pip install -r "$reqs"; done

WORKDIR /ComfyUI

EXPOSE 8888

CMD ["python", "main.py", "--listen", "--port", "8888"]