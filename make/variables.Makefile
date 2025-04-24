ROOT_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

# NOTE: to support nideovim in nideovim
unexport ANTHROPIC_API_KEY
unexport INSTANCE_ID
unexport PROJECT_NAME
unexport USER_HOME_DIR
unexport VOLUME_DIR_NAME
