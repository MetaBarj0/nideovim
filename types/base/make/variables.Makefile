ifeq ($(MAKELEVEL), 0)
	# NOTE: those are defined in the system environment variables
	undefine PROJECT_NAME
	undefine COMPOSE_PROJECT_NAME
	undefine VOLUME_DIR_NAME
	undefine ANTHROPIC_API_KEY
endif

include Makefile.env

export
