FROM nvidia/cuda:13.0.0-cudnn-devel-ubuntu24.04

RUN apt update && apt install -y git python3.12-venv curl
RUN python3.12 -m venv /etc/venv
RUN /etc/venv/bin/pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /etc/comfyui/
VOLUME ["/etc/ComfyUI/models/checkpoints", "/etc/ComfyUI/models/vae"]
RUN git clone https://github.com/madebyollin/taesd.git /etc/ComfyUI/models/vae_approx/
EXPOSE 8188
RUN /etc/venv/bin/pip install pyyaml tqdm

RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
RUN apt-get update
RUN export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.17.8-1 && apt install -y \
      nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}

CMD ["/etc/venv/bin/python", "/etc/comfyui/main.py", "--preview-method", "taesd"]