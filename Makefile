MAKEFILE_DIR := $(shell dirname $(MAKEFILE_LIST))

include make.d/Makefile.targets
include Makefile.env

export

help:
	@. make.d/scripts/help.sh

init:
	@. make.d/scripts/init.sh

build:
	@. make.d/scripts/build.sh

up:
	@. make.d/scripts/up.sh

shell:
down:
