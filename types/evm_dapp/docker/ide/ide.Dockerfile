# NOTE: As there is an ancestor for this type, a base image is specified here.
#       Take a look in the build script attached to the build make target to
#       get more insights.
ARG BASE_IMAGE=nideovim_evm_dapp_ide_image

# hadolint ignore=DL3006
FROM ${BASE_IMAGE} AS install_slither_analyzer
ARG USER_NAME=root
USER root
# hadolint ignore=DL3008
RUN \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  pipx
USER ${USER_NAME}
# hadolint ignore=DL3013
RUN pipx install slither-analyzer \
  && pipx ensurepath

FROM install_slither_analyzer AS install_foundry
ARG USER_NAME=root
ARG USER_HOME_DIR=/root
USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -L https://foundry.paradigm.xyz | bash
RUN FOUNDRY_DIR=${USER_HOME_DIR}/.foundry ${USER_HOME_DIR}/.foundry/bin/foundryup
ENV FOUNDRY_DIR=${USER_HOME_DIR}/.foundry
ENV PATH=${PATH}:${FOUNDRY_DIR}/bin

# The last build stage must named 'end'
FROM install_foundry as end
ARG USER_NAME=root
USER ${USER_NAME}
RUN npm install -g lcov-parse@1.0.0
