Makefile.env:
	@. make/scripts/Makefile.env.sh

clean: down
	@. make/scripts/clean.sh

build: target_stage=end
build: build_type=unoptimized

inspect:
	@. make/scripts/inspect.sh

nuke: down_removes_volumes=yes
nuke:
	@. make/scripts/down.sh
