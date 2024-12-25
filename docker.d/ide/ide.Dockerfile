FROM debian:stable-slim AS upgraded
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

FROM core_packages AS install_docker_cli
# docker installation for debian
# see:
# https://docs.docker.com/engine/install/debian/#install-using-the-repository
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl gnupg
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  docker-ce-cli docker-buildx-plugin docker-compose-plugin
# Adding the docker group manually

FROM install_docker_cli AS llvm
ARG LLVM_VERSION=19
RUN wget https://apt.llvm.org/llvm.sh \
  && chmod +x llvm.sh
RUN ./llvm.sh ${LLVM_VERSION} all
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/ld ld /usr/bin/lld-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/lld lld /usr/bin/lld-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/lldb-dap lldb-dap /usr/bin/lldb-dap-${LLVM_VERSION} 100

FROM llvm AS install_essential_ide_packages
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get install -y --no-install-recommends \
  openssh-client curl unzip tar gzip tmux luarocks coreutils ripgrep \
  lua5.1-dev python3 python3-pynvim gcc fd-find \
  python3-venv less
RUN rm -rf /var/cache/apt

FROM install_essential_ide_packages AS setup_rootless
ARG ROOTLESS=0
ARG USER_GID=0
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
ARG USER_UID=0
RUN <<EOF
  prepare_docker_group() {
    groupadd -o -g ${USER_GID} docker
  }

  add_non_root_user() {
    useradd \
      -d ${USER_HOME_DIR} \
      -m -s /bin/bash -G docker \
      -u ${USER_UID} \
      ${USER_NAME}
  }

  main() {
    if [ ${ROOTLESS} -eq 0 ]; then
      exit 0
    else
      prepare_docker_group &&
        add_non_root_user
    fi
  }

  main
EOF

FROM setup_rootless AS fetch_nodejs
ARG NODEJS_VERSION
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER root
RUN \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  wget curl jq
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
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
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER root
RUN \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  xz-utils
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
RUN tar x -f node-*-linux-*.tar.xz

FROM setup_rootless AS install_nodejs
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
RUN mkdir ${USER_HOME_DIR}/.nodejs
WORKDIR ${USER_HOME_DIR}/.nodejs
COPY --from=extract_nodejs ${USER_HOME_DIR}/node-*-linux-*/ .
ENV NODEJS_INSTALL_DIR=${USER_HOME_DIR}/.nodejs
ENV PATH=${PATH}:${NODEJS_INSTALL_DIR}/bin

FROM install_nodejs AS install_npm_packages
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
RUN \
  npm install --global \
    npm-check-updates neovim tree-sitter-cli

FROM setup_rootless AS build_neovim
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER root
RUN \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  gettext cmake ninja-build lua5.1
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
RUN git clone --branch master --depth=1 \
  https://github.com/neovim/neovim
WORKDIR ${USER_HOME_DIR}/neovim
RUN make \
  CMAKE_BUILD_TYPE=Release \
  CMAKE_INSTALL_PREFIX=${USER_HOME_DIR}/.neovim
RUN make install

FROM setup_rootless AS install_golang_1_23_3
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER root
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get install -y --no-install-recommends \
  golang
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
RUN go install golang.org/dl/go1.23.3@latest
WORKDIR ${USER_HOME_DIR}/go/bin
RUN ./go1.23.3 download

FROM setup_rootless AS install_latest_rust
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

FROM setup_rootless AS build_lazygit
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
COPY --from=install_golang_1_23_3 --chown=${USER_NAME}:${USER_NAME} ${USER_HOME_DIR}/sdk/go1.23.3/ ${USER_HOME_DIR}/sdk/go1.23.3/
ENV PATH=${USER_HOME_DIR}/sdk/go1.23.3/bin/:${PATH}
COPY --from=install_latest_rust --chown=${USER_NAME}:${USER_NAME} ${USER_HOME_DIR}/.cargo/ ${USER_HOME_DIR}/.cargo/
COPY --from=install_latest_rust --chown=${USER_NAME}:${USER_NAME} ${USER_HOME_DIR}/.rustup/ ${USER_HOME_DIR}/.rustup/
ENV PATH=${USER_HOME_DIR}/.cargo/bin/:${PATH}
RUN git clone --depth 1 https://github.com/jesseduffield/lazygit.git
WORKDIR ${USER_HOME_DIR}/lazygit
RUN go install
RUN cargo install ast-grep --locked

FROM setup_rootless AS build_fzf
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
COPY --from=install_golang_1_23_3 --chown=${USER_NAME}:${USER_NAME} ${USER_HOME_DIR}/sdk/go1.23.3/ ${USER_HOME_DIR}/sdk/go1.23.3/
ENV PATH=${USER_HOME_DIR}/sdk/go1.23.3/bin/:${PATH}
RUN git clone --branch=master --depth=1 https://github.com/junegunn/fzf.git
WORKDIR ${USER_HOME_DIR}/fzf
RUN FZF_VERSION=HEAD FZF_REVISION=HEAD make install

FROM install_npm_packages AS install_built_oss
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
RUN mkdir .bin
COPY \
  --from=build_lazygit \
  --chown=${USER_NAME}:${USER_NAME} \
  ${USER_HOME_DIR}/go/bin/lazygit \
  ${USER_HOME_DIR}/.cargo/bin/sg \
  ${USER_HOME_DIR}/.bin
COPY --from=build_fzf \
  --chown=${USER_NAME}:${USER_NAME} \
  ${USER_HOME_DIR}/fzf/bin/fzf* ${USER_HOME_DIR}/.bin
COPY --from=build_neovim \
  --chown=${USER_NAME}:${USER_NAME} \
  ${USER_HOME_DIR}/.neovim ${USER_HOME_DIR}/.neovim/

FROM install_built_oss AS full_upgrade_no_cache
ARG CACHE_NONCE=1
USER root
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update \
  && apt-get full-upgrade -y --no-install-recommends

# TODO: design an optimize image feature to speed up image building at development stages
FROM scratch AS end
ARG COMPOSE_PROJECT_NAME=deovim
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
ARG VOLUME_DIR_NAME=workspace
USER root
COPY --from=full_upgrade_no_cache / /
WORKDIR ${USER_HOME_DIR}
COPY ide.entrypoint.sh .bin/ide.entrypoint.sh
RUN chown -R ${USER_NAME}:${USER_NAME} ${USER_HOME_DIR}
USER ${USER_NAME}
RUN mkdir -p .config .local tmp ${VOLUME_DIR_NAME}
RUN touch .config/.volume .local/.volume tmp/.volume ${VOLUME_DIR_NAME}/.volume
ENV NODEJS_INSTALL_DIR=${USER_HOME_DIR}/.nodejs
ENV NEOVIM_INSTALL_DIR=${USER_HOME_DIR}/.neovim
ENV PATH=${PATH}:${NODEJS_INSTALL_DIR}/bin:${NEOVIM_INSTALL_DIR}/bin:${USER_HOME_DIR}/.bin
LABEL project=${COMPOSE_PROJECT_NAME}
