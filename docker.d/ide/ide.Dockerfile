# TODO: ideally rootless?
FROM debian:bookworm-slim AS upgraded
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update \
  && apt-get full-upgrade -y --no-install-recommends

FROM upgraded AS core_packages
RUN \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  make git ca-certificates wget lsb-release software-properties-common gnupg \
  curl

# TODO: rootless stage
FROM core_packages AS llvm
ARG LLVM_VERSION=18
RUN wget https://apt.llvm.org/llvm.sh \
  && chmod +x llvm.sh
RUN ./llvm.sh ${LLVM_VERSION} all
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/ld ld /usr/bin/lld-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/lld lld /usr/bin/lld-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/lldb-dap lldb-dap /usr/bin/lldb-dap-${LLVM_VERSION} 100

# TODO: self built stuff as rootless
FROM llvm AS build_neovim
RUN \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  gettext cmake ninja-build lua5.1
WORKDIR /root
RUN git clone --branch master --depth=1 \
  https://github.com/neovim/neovim
WORKDIR /root/neovim
RUN make \
  CMAKE_BUILD_TYPE=Release \
  CMAKE_INSTALL_PREFIX=/usr/local
RUN make install

FROM llvm AS install_golang_1_23_3
WORKDIR /root
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get install -y --no-install-recommends \
  golang
RUN go install golang.org/dl/go1.23.3@latest
WORKDIR /root/go/bin
RUN ./go1.23.3 download

# TODO: Rootless stuff here
FROM llvm AS install_latest_rust
WORKDIR /root
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

FROM llvm AS build_lazygit
WORKDIR /root
COPY --from=install_golang_1_23_3 /root/sdk/go1.23.3/ /root/sdk/go1.23.3/
ENV PATH=/root/sdk/go1.23.3/bin/:${PATH}
COPY --from=install_latest_rust /root/.cargo/ /root/.cargo/
COPY --from=install_latest_rust /root/.rustup/ /root/.rustup/
ENV PATH=/root/.cargo/bin/:${PATH}
RUN git clone --depth 1 https://github.com/jesseduffield/lazygit.git
WORKDIR /root/lazygit
RUN go install
RUN cargo install ast-grep --locked

FROM llvm AS install_esential_ide_packages
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get install -y --no-install-recommends \
  openssh-client curl unzip tar gzip tmux luarocks coreutils ripgrep \
  lua5.1-dev python3 python3-pynvim gcc fd-find \
  python3-venv less
RUN rm -rf /var/cache/apt

FROM install_esential_ide_packages AS fetch_nodejs
ARG NODEJS_VERSION
RUN \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  wget curl jq
WORKDIR /root
RUN \
  [ $(arch) = 'aarch64' ] && nodejs_arch='arm64' \
  ; [ $(arch) = 'x86_64' ] && nodejs_arch='x64' \
  ; [ "${NODEJS_VERSION}" != 'latest' ] \
  && wget https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-${nodejs_arch}.tar.xz \
  || ( \
  query='sort_by(.tag_name) | reverse | .[0].tag_name' \
  && version=$(curl -s https://api.github.com/repos/nodejs/node/releases \
  | jq "${query}" \
  | sed 's/"//g') \
  && wget https://nodejs.org/dist/${version}/node-${version}-linux-${nodejs_arch}.tar.xz \
  )

FROM fetch_nodejs AS extract_nodejs
RUN \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  xz-utils
WORKDIR /root
RUN tar x -f node-*-linux-*.tar.xz

FROM install_esential_ide_packages AS install_nodejs
RUN mkdir /root/.nodejs
WORKDIR /root/.nodejs
COPY --from=extract_nodejs /root/node-*-linux-*/ .
ENV NODEJS_INSTALL_DIR=/root/.nodejs
ENV PATH=${PATH}:${NODEJS_INSTALL_DIR}/bin

FROM install_nodejs AS install_npm_packages
RUN \
  npm install --global \
  npm-check-updates neovim tree-sitter-cli

FROM install_npm_packages AS install_neovim_and_lazygit
COPY \
  --from=build_lazygit \
  /root/go/bin/lazygit \
  /root/.cargo/bin/sg \
  /usr/local/bin/
COPY --from=build_neovim \
  /usr/local/ /usr/local/

FROM install_neovim_and_lazygit AS full_upgrade_no_cache
ARG CACHE_NONCE=1
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update \
  && apt-get full-upgrade -y --no-install-recommends

FROM scratch AS end
ARG COMPOSE_PROJECT_NAME=deovim
COPY --from=full_upgrade_no_cache / /
WORKDIR /root
COPY ide.entrypoint.sh .bin/ide.entrypoint.sh
ENV NODEJS_INSTALL_DIR=/root/.nodejs
ENV PATH=${PATH}:${NODEJS_INSTALL_DIR}/bin
LABEL project=${COMPOSE_PROJECT_NAME}

# TODO: extra packages specified in env?
