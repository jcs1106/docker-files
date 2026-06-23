FROM node:24-slim
WORKDIR /app

# 安装系统依赖 + chrome-headless-shell 所需库
RUN apt update && apt install -y --no-install-recommends \
    libvips libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev \
    libnss3 libxkbcommon0 libgtk-3-0 libgbm1 libasound2 \
    libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 \
    libxfixes3 libxi6 libxrandr2 libxtst6 libcups2 libdrm2 \
    libdbus-1-3 libexpat1 \
    && rm -rf /var/lib/apt/lists/*

# 通过 Puppeteer 安装 chrome-headless-shell（~100MB，远小于完整 chromium 的 ~300MB）
RUN npx puppeteer browsers install chrome-headless-shell \
    && corepack enable \
    && corepack prepare pnpm@latest-10 --activate \
    && pnpm config set store-dir /cache/.pnpm-store

USER node
CMD ["node"]
