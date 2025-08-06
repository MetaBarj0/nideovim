# NOTE: As there is an ancestor for this type, a base image is specified here.
#       Take a look in the build script attached to the build make target to
#       get more insights.
ARG BASE_IMAGE=nideovim_ton_dev_ide_image

# The last build stage must named 'end'
# hadolint ignore=DL3006
FROM ${BASE_IMAGE} AS end
ARG USER_NAME=root
USER root
# hadolint ignore=DL3008
RUN \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  ccache cmake ninja-build pkg-config zlib1g-dev libjemalloc-dev liblz4-dev \
  libsodium-dev libmicrohttpd-dev autoconf automake libtool
USER ${USER_NAME}
