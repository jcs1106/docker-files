FROM node:24-slim
WORKDIR /app

# 安装系统依赖
RUN apt update \
    && apt install -y --no-install-recommends \
        libvips libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev \
        libnss3 libxkbcommon0 libgtk-3-0 libgbm1 libasound2 chromium \
    && rm -rf /var/lib/apt/lists/*

# corepack enable 需要写入 /usr/local/bin，必须在 root 下执行
RUN corepack enable && corepack use pnpm@latest-10

USER node
RUN pnpm config set store-dir /cache/.pnpm-store
    


USER node
CMD ["node"]
