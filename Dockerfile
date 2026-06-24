FROM node:24-slim
WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libvips libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev \
        libnss3 libxkbcommon0 libgtk-3-0 libgbm1 libasound2 chromium \
    && rm -rf /var/lib/apt/lists/* \
    && corepack enable \
    && corepack use pnpm@10.34.3 \
    && pnpm config set --global store-dir /cache/.pnpm-store \
    && mkdir -p /cache/.pnpm-store \
    && chown -R node:node /cache \
    && rm -rf /root/.cache

USER node

CMD ["node"]
