# NOTE: To support nideovim in nideovim
ifeq ($(MAKELEVEL), 0)
	# NOTE: those are defined in the system environment variables
	undefine ANTHROPIC_API_KEY
	undefine COMPOSE_PROJECT_NAME
	undefine INSTANCE_ID
	undefine PROJECT_NAME
	undefine USER_HOME_DIR
	undefine VOLUME_DIR_NAME
endif

include Makefile.env

export
