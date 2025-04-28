.PHONY: all help help-help new new-help set-default set-default-help \
	instance-help instance-help-help delete delete-help list list-help list-types \
	list-types-help migrate migrate-help

SHELL := /bin/bash

include make/variables.Makefile
include make/targets.Makefile

export

all: help

help:
	@. scripts/help/help.sh

help-help:
	@. scripts/help/help-help.sh

new:
	@. scripts/new.sh

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

delete:
	@. scripts/delete.sh

delete-help:
	@. scripts/help/delete-help.sh

list:
	@. scripts/list.sh

list-help:
	@. scripts/help/list-help.sh

list-types:
	@. scripts/list-types.sh

list-types-help:
	@. scripts/help/list-types-help.sh

migrate:
	@. scripts/migrate.sh

migrate-help:
	@. scripts/help/migrate-help.sh
