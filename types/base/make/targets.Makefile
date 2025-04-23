Makefile.env:
	@. scripts/Makefile.env.sh

build: TARGET_STAGE=end

nuke: DOWN_REMOVES_VOLUMES=yes

upgrade: TARGET_STAGE=end
upgrade: LAST_UPGRADE_TIMESTAMP=$(shell date +%s)
