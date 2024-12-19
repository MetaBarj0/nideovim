main() {
  docker build \
    --build-arg CACHE_NONCE="$(date +%s)" \
    --build-arg LLVM_VERSION="${LLVM_VERSION}" \
    -t "${COMPOSE_PROJECT_NAME}"_ide_image \
    -f docker.d/ide/ide.Dockerfile \
    docker.d/ide
}

main
