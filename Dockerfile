FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

WORKDIR /app

RUN git clone https://github.com/comfyanonymous/ComfyUI

WORKDIR /app/ComfyUI

RUN python -m venv venv
ENV PATH="/app/ComfyUI/venv/bin:$PATH"

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v1.0.0/nunchaku-1.0.0+torch2.9-cp312-cp312-linux_x86_64.whl

WORKDIR /app/ComfyUI/custom_nodes
RUN git clone https://github.com/nunchaku-tech/ComfyUI-nunchaku

RUN for reqs in $(find . -name "requirements.txt"); do pip install --no-cache-dir -r "$reqs"; done

WORKDIR /app/ComfyUI
COPY extra_model_paths.yaml extra_model_paths.yaml

EXPOSE 8188

CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]