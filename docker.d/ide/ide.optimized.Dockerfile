ARG COMPOSE_PROJECT_NAME=nideovim

FROM ${COMPOSE_PROJECT_NAME}_ide_image AS unoptimized_ide_image

# `end` stage name is important as it is the only stage name allowing image to be optimized
FROM scratch AS end
ARG COMPOSE_PROJECT_NAME=nideovim
ARG USER_HOME_DIR=/root
ARG USER_NAME=root
ARG VOLUME_DIR_NAME=workspace
COPY --from=unoptimized_ide_image / /
USER ${USER_NAME}
ENV NODEJS_INSTALL_DIR=${USER_HOME_DIR}/.nodejs
ENV NEOVIM_INSTALL_DIR=${USER_HOME_DIR}/.neovim
ENV PATH=${PATH}:${NODEJS_INSTALL_DIR}/bin:${NEOVIM_INSTALL_DIR}/bin:${USER_HOME_DIR}/.bin
LABEL project=${COMPOSE_PROJECT_NAME}
