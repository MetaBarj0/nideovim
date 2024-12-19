#/bin/env sh

# TODO: compose this
main() {
  docker run --init --rm -it \
    --platform linux/aarch64 \
    -v /Users/sebastienlevy/workspace/github/environments:/root/environments \
    -v /Users/sebastienlevy/workspace/trinitycore/server/TrinityCore:/root/TrinityCore \
    -v /Users/sebastienlevy/.ssh:/root/.ssh \
    --security-opt seccomp=unconfined \
    neovim_next
}

main
