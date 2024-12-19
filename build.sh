#/bin/env sh

main() {
  docker build \
    --build-arg CACHE_NONCE=$(date +%s) \
    -t neovim_next \
    -f ./Dockerfile \
    .
}

main
