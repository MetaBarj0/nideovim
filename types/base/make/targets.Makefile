Makefile.env:
	@. scripts/Makefile.env.sh

build: TARGET_STAGE=end

inspect:
	@. scripts/inspect.sh

nuke: down_removes_volumes=yes
nuke:
	@. scripts/down.sh
