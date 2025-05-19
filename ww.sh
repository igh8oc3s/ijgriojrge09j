#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get install -y \
    wget \
    git \
    curl \
    nano \
    libglm-dev \
    cuda-toolkit-12-6

curl -L -O "https://github.com/conda-forge/miniforge/releases/download/25.3.0-1/Miniforge3-25.3.0-1-Linux-x86_64.sh" \
    && bash Miniforge3-25.3.0-1-Linux-x86_64.sh -b -p /opt/mamba \
    && rm Miniforge3-25.3.0-1-Linux-x86_64.sh

export PATH="/opt/mamba/bin:$PATH"

git clone https://github.com/KovenYu/WonderWorld.git --recursive && cd WonderWorld \
    && mamba create -y --name wonderworld python=3.10 \
    && . /opt/mamba/etc/profile.d/conda.sh \
    && sed -i '18i #include <float.h>' ./submodules/simple-knn/simple_knn.cu

conda activate wonderworld \
    && conda install -y -c fvcore -c iopath -c conda-forge fvcore iopath

python -m venv .venv \
    && source .venv/bin/activate
    && pip install torch torchvision torchaudio \
    && pip install "git+https://github.com/facebookresearch/pytorch3d.git@stable" \
    && wget https://github.com/THU-MIG/RepViT/releases/download/v1.0/repvit_sam.pt

pip install submodules/depth-diff-gaussian-rasterization-min/ \
    && pip install submodules/simple-knn/ \
    && pip install -r requirements.txt \
    && pip install openai==1.55.3 httpx==0.27.2 --force-reinstall --quiet \
    && python -m spacy download en_core_web_sm \
    && cd ./RepViT/sam && pip install -e . && cd ../..
