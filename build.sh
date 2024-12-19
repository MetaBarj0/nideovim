#/bin/env sh

# TODO: remove platform specific stuff
main() {
  docker build \
    --platform linux/aarch64 \
    -t neovim_next \
    -f ./Dockerfile \
    .
}

main
