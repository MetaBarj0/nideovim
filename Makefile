.PHONY: all help help-help new new-help

SHELL := /bin/bash

include make/targets.Makefile

all: help

help:
	@. scripts/help/help.sh

help-help:
	@. scripts/help/help-help.sh

new:
	@. scripts/new.sh

new-help:
	@. scripts/help/new-help.sh
