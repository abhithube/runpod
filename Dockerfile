FROM runpod/pytorch:0.7.0-ubuntu2404-cu1263-torch271 AS builder

# Clone ComfyUI repo
RUN git clone https://github.com/comfyanonymous/ComfyUI

WORKDIR /ComfyUI

COPY extra_model_paths.yaml extra_model_paths.yaml

# Install ComfyUI dependencies
RUN pip install --disable-pip-version-check --no-cache-dir -r requirements.txt

WORKDIR /ComfyUI/custom_nodes

# Clone custom node repos
RUN git clone https://github.com/Comfy-Org/ComfyUI-Manager && \
    git clone https://github.com/rgthree/rgthree-comfy && \
    git clone https://github.com/city96/ComfyUI-GGUF

# Install custom node dependencies
RUN for reqs in $(find . -name "requirements.txt"); do pip install --disable-pip-version-check --no-cache-dir -r "$reqs"; done

FROM runpod/pytorch:0.7.0-ubuntu2404-cu1263-torch271

COPY --from=builder /ComfyUI /ComfyUI
COPY --from=builder /usr/local/lib/python*/site-packages /usr/local/lib/python*/site-packages

WORKDIR /ComfyUI

EXPOSE 8888

CMD ["python", "main.py", "--listen", "--port", "8888"]