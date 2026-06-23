#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="docker-files-test:latest"
CONTAINER_NAME="docker-files-test-$$"
DOCKERFILE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "============================================"
echo "Step 1/4: Building image from Dockerfile..."
echo "============================================"
docker build -t "$IMAGE_NAME" "$DOCKERFILE_DIR"
echo ""

echo "============================================"
echo "Step 2/4: Checking installed tools..."
echo "============================================"
docker run --rm --name "${CONTAINER_NAME}-check" \
  --user node \
  "$IMAGE_NAME" \
  sh -c '
    echo "Node.js: $(node -v)"
    echo "pnpm:    $(pnpm -v)"
    echo "---"
    npx puppeteer browsers list
  '
echo ""

echo "============================================"
echo "Step 3/4: Running Puppeteer test..."
echo "============================================"
docker run --rm --name "${CONTAINER_NAME}-test" \
  --user node \
  --cap-add=SYS_ADMIN \
  -v "$DOCKERFILE_DIR/test-puppeteer.js:/app/test-puppeteer.js:ro" \
  "$IMAGE_NAME" \
  sh -c 'pnpm add puppeteer && node /app/test-puppeteer.js'
echo ""

echo "============================================"
echo "Step 4/4: Image size report"
echo "============================================"
docker images "$IMAGE_NAME" --format "Image size: {{.Size}}"
echo ""

echo "All tests passed. Clean up with: docker rmi $IMAGE_NAME"
