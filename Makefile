MAKEFILE_DIR := $(shell dirname $(MAKEFILE_LIST))

include make.d/Makefile.targets
include Makefile.env

export

MAKEFLAGS += --no-print-directory

help::
	@. make.d/scripts/help.sh

init:
	@. make.d/scripts/init.sh

build:
	@. make.d/scripts/build.sh

up:
	@. make.d/scripts/up.sh

shell:
	@. make.d/scripts/shell.sh

down:
	@. make.d/scripts/down.sh
