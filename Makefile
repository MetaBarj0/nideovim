.PHONY: all help help-help new new-help set-default set-default-help \
	instance-help instance-help-help delete delete-help

SHELL := /bin/bash

include make/targets.Makefile

all: help

help:
	@. scripts/help/help.sh

help-help:
	@. scripts/help/help-help.sh

new:
	@. scripts/new.sh

delete:
	@. scripts/delete.sh

delete-help:
	@. scripts/help/delete-help.sh

new-help:
	@. scripts/help/new-help.sh

set-default:
	@. scripts/set-default.sh

set-default-help:
	@. scripts/help/set-default-help.sh

instance-help:
	@. scripts/instance-help.sh

instance-help-help:
	@. scripts/help/instance-help-help.sh
