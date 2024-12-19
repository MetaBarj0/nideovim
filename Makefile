MAKEFILE_DIR := $(shell dirname $(MAKEFILE_LIST))

include make.d/Makefile.targets
include Makefile.env

export

help:
	@. make.d/scripts/help.sh

build:
	@. make.d/scripts/build.sh

up:
shell:
down:
