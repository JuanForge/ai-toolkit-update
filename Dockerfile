FROM docker.io/nvidia/cuda:12.8.1-devel-ubuntu24.04

ARG AI_TOOLKIT_COMMIT=7e7053fc9a2e78df999d05ab18d1e64af02834a5

RUN userdel -r ubuntu
RUN useradd -m -u 1000 app
RUN mkdir -p /app && chown -R app:app /app

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/app/.venv/bin:/home/app/.local/bin:$PATH"

# ref https://en.wikipedia.org/wiki/CUDA
# ENV TORCH_CUDA_ARCH_LIST="8.0 8.6 8.9 9.0 10.0 12.0"

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    curl \
    build-essential \
    cmake \
    wget \
    python3.12 \
    python3-pip \
    python3-dev \
    python3-wheel \
    python3-venv \
    ffmpeg \
    python3-opencv \
    openssl \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN curl -sL https://deb.nodesource.com/setup_23.x | bash \
    && apt-get update \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* || true

USER app

WORKDIR /app
RUN git clone https://github.com/ostris/ai-toolkit.git . \
    && git checkout ${AI_TOOLKIT_COMMIT}

RUN python3.12 -m venv .venv

RUN /app/.venv/bin/python -m pip install --no-cache-dir  setuptools
RUN /app/.venv/bin/python -m pip install --no-cache-dir torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url https://download.pytorch.org/whl/cu128
#                                                              2.9.1               0.24.1             2.9.1

RUN /app/.venv/bin/python -m pip install --no-cache-dir -r requirements.txt
#                                                                  ==69.5.1



WORKDIR /app/ui
RUN npm ci
RUN npm run update_db
RUN npm run build

EXPOSE 8675

#RUN chmod +x /app/start.sh

#CMD ["/app/start.sh"]
CMD ["npm run start"]