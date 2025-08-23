FROM nvidia/cuda:13.0.0-cudnn-devel-ubuntu24.04

RUN apt update && apt install -y git python3.12-venv curl
RUN python3.12 -m venv /etc/venv
RUN /etc/venv/bin/pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /etc/comfyui/
VOLUME ["/etc/comfyui/models/checkpoints", "/etc/comfyui/models/vae"]
RUN rm /etc/comfyui/models/vae_approx/put_taesd_encoder_pth_and_taesd_decoder_pth_here
RUN git clone https://github.com/madebyollin/taesd.git /etc/comfyui/models/vae_approx/
EXPOSE 8188

RUN /etc/venv/bin/pip install -r /etc/comfyui/requirements.txt
CMD ["/etc/venv/bin/python", "/etc/comfyui/main.py", "--preview-method", "taesd", "--listen", "0.0.0.0"]