# NOTE: As there is an ancestor for this type, a base image is specified here.
#       Take a look in the build script attached to the build make target to
#       get more insights.
ARG BASE_IMAGE=nideovim_zk_dapp_ide_image

FROM ${BASE_IMAGE} AS install_packages
ARG USER_NAME=root
USER root
# hadolint ignore=DL3008
RUN \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  jq
USER ${USER_NAME}

FROM install_packages AS install_noir
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -L \
  https://raw.githubusercontent.com/noir-lang/noirup/refs/heads/main/install \
  | bash
ENV NARGO_BIN_DIR=${USER_HOME_DIR}/.nargo/bin
ENV PATH=${PATH}:${NARGO_BIN_DIR}
RUN noirup

FROM install_noir AS install_barretenberg
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -L \
  https://raw.githubusercontent.com/AztecProtocol/aztec-packages/refs/heads/next/barretenberg/bbup/install \
  | bash
ENV BB_BIN_DIR=${USER_HOME_DIR}/.bb
ENV PATH=${PATH}:${BB_BIN_DIR}
RUN bbup

FROM install_barretenberg AS install_configuration
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
RUN mkdir configuration
COPY configuration configuration/
RUN find -- configuration/*/USER_HOME_DIR \
  -maxdepth 1 -not -name 'USER_HOME_DIR' \
  -exec cp -r {} ${USER_HOME_DIR} ';'

# The last build stage must named 'end'
FROM install_barretenberg AS end
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
COPY --from=install_configuration \
  --chown=${USER_NAME}:${USER_NAME} \
  ${USER_HOME_DIR}/.config/ .config/
