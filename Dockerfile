FROM debian:trixie-slim AS upgraded
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
  make git ca-certificates wget lsb-release software-properties-common gnupg

FROM core_packages AS llvm
RUN wget https://apt.llvm.org/llvm.sh \
  && chmod +x llvm.sh
RUN ./llvm.sh 18 all
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 100
RUN update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-18 100
RUN update-alternatives --install /usr/bin/lld lld /usr/bin/lld-18 100
RUN update-alternatives --install /usr/bin/lldb-dap lldb-dap /usr/bin/lldb-dap-18 100

# TODO: duplicate pkg installation
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

FROM llvm AS built_packages
WORKDIR /root
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get install -y --no-install-recommends \
  golang cargo
RUN git clone --depth 1 https://github.com/jesseduffield/lazygit.git \
  && cd lazygit \
  && go install
RUN cargo install ast-grep --locked

FROM llvm AS packages
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get install -y --no-install-recommends \
  openssh-client curl unzip tar gzip tmux luarocks coreutils ripgrep \
  lua5.1-dev nodejs npm tree-sitter-cli python3 python3-pynvim gcc fd-find \
  python3-venv less
RUN rm -rf /var/cache/apt

FROM packages AS neovim_packages
RUN \
  npm install --global \
  npm-check-updates neovim

FROM scratch
COPY --from=neovim_packages / /
COPY \
  --from=built_packages \
  /root/go/bin/lazygit \
  /root/.cargo/bin/sg \
  /usr/local/bin/
COPY --from=build_neovim \
  /usr/local/ /usr/local/
WORKDIR /root
COPY entrypoint.sh .
COPY .bashrc .
ENV ENV=/root/.rc
ENTRYPOINT ["/root/entrypoint.sh"]
LABEL project="neovim_config_context"
