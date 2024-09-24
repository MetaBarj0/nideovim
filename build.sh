#/bin/env sh

main() {
  docker build \
    --platform linux/aarch64 \
    -t neovim_next \
    -f ./Dockerfile \
    .
}

main
