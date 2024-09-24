#/bin/env sh

export BUILDX_EXPERIMENTAL=1

main() {
  docker buildx debug build \
    --platform linux/aarch64 \
    -t neovim_next \
    -f ./Dockerfile \
    .
}

main
