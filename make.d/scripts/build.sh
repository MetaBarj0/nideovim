main() {
  docker build \
    --build-arg CACHE_NONCE="$(date +%s)" \
    -t "${COMPOSE_PROJECT_NAME}"_ide_image \
    -f docker.d/ide/ide.Dockerfile \
    docker.d/ide
}

main
