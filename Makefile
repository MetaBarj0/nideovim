.PHONY: all help help-help new new-help

all: help

help:
	@. scripts/help/help.sh

help-help:
	@. scripts/help/help-help.sh

new:
	@. scripts/new.sh

new-help:
