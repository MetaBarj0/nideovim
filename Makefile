.PHONY: all help help-help new new-help

SHELL := /bin/bash

all: help

help:
	@. scripts/help/help.sh

help-help:
	@. scripts/help/help-help.sh

new:
	@. scripts/new.sh

new-help:
	@. scripts/help/new-help.sh
