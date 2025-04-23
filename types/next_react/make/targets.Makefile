# NOTE: this target is implicitely run when the Makefile is interpreted because
#       there is an explicit include Makefile.env directive in the ancestor
#       Makefile.
#       Though this target execute logic inherited from the ancestor, you need
#       it here to create the Makefile.env file in the right place, that is
#       your type directory instead of the ancestor type directory.
Makefile.env:
	@. ${ANCESTOR_DIR}/scripts/Makefile.env.sh

# NOTE: target variable defined for the build target. As you will see in the
#       build.sh file, specifying the stage is mandatory here. The end target
#       must exist as an alias on a build stage in the ide.Dockerfile recipe.
build: TARGET_STAGE=end
