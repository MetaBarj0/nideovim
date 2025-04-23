Makefile.env:
	@. scripts/Makefile.env.sh

build: TARGET_STAGE=end

inspect:
	@. scripts/inspect.sh

# TODO: move obvious targets in Makefile
nuke: DOWN_REMOVES_VOLUMES=yes
nuke:
	@. scripts/down.sh

upgrade: TARGET_STAGE=end
upgrade: LAST_UPGRADE_TIMESTAMP=$(shell date +%s)
