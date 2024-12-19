main() {
  docker build \
    --build-arg CACHE_NONCE="$(date +%s)" \
    --build-arg COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME}" \
    --build-arg LLVM_VERSION="${LLVM_VERSION}" \
    --build-arg NODEJS_VERSION="${NODEJS_VERSION}" \
    --target="${target_stage?}" \
    -t "${COMPOSE_PROJECT_NAME}"_ide_image \
    -f docker.d/ide/ide.Dockerfile \
    docker.d/ide
}

main
