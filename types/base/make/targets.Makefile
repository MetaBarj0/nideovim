Makefile.env:
	@. scripts/Makefile.env.sh

build: target_stage=end
build: build_type=unoptimized

inspect:
	@. scripts/inspect.sh

nuke: down_removes_volumes=yes
nuke:
	@. scripts/down.sh
