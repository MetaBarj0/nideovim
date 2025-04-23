# NOTE: mandatory, by default make looks to prefer /bin/sh otherwise
SHELL := /bin/bash

# NOTE: help to keep a clean structure. Define all variables in this file. You
#       can define as much variable as you wish of course. Keep in mind some
#       are mandatory.
include make/variables.Makefile

# NOTE: help to keep a clean structure. Ideally, you define in this file all
#       internal target or target variables to de-clutter the main Makefile.
include make/targets.Makefile

# NOTE: if you have to provide supplemental facilities in your docker image,
#       you will have to provide your own build make target. However, you can
#       rely a lot on the base type facilities as you can see in the target
#       definition. Here, you first build the ancestor image before building
#       your own.
build:
	@$(MAKE) -C ancestor build
	@. scripts/build.sh

# NOTE: support for upgrading this type docker image. Removing this target and
#       running make upgrade for your type would have the effect to only
#       upgrade the base iamge (provided the base image is the eldest ancestor)
upgrade:
	@$(MAKE) -C ancestor upgrade
	@. scripts/build.sh

# NOTE: any target not known from this Makefile is forwarded to the ancestor
#       Makefile. It is a convenient way to inherit target from the ancestor of
#       your type.
%:
	@$(MAKE) -C ancestor $@

