# NOTE: As there is an ancestor for this type, a base image is specified here.
#       Take a look in the build script attached to the build make target to
#       get more insights.
ARG BASE_IMAGE=nideovim_next_react_ide_image

# NOTE: The last build stage must named 'end'. Take a look in the build script
#       attached to the build make target to get more insights

# hadolint ignore=DL3006
FROM ${BASE_IMAGE} AS end
ARG CREATE_NEXT_APP_MAJOR_VERSION=15
ARG USER_NAME=root
USER ${USER_NAME}
RUN npm install -g create-next-app@^${CREATE_NEXT_APP_MAJOR_VERSION}

