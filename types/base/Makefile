SHELL := /bin/bash

include make/variables.Makefile
include make/targets.Makefile

help:
	@. scripts/help.sh

init:
	@. scripts/init.sh

build:
	@. scripts/build.sh

up:
	@. scripts/up.sh

login:
	@. scripts/login.sh

down:
	@. scripts/down.sh

clean: down
	@. scripts/clean.sh

upgrade:
	@. scripts/build.sh
