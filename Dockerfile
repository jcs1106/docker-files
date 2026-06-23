FROM node:24-slim
WORKDIR /app

# 安装系统依赖并配置 pnpm（合并 RUN 减少镜像层）
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libvips libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev \
        libnss3 libxkbcommon0 libgtk-3-0 libgbm1 libasound2 chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && corepack enable \
    && corepack use pnpm@latest-10 \
    && rm -rf /root/.cache

USER node
RUN pnpm config set store-dir /cache/.pnpm-store

CMD ["node"]
