# NOTE: this target is implicitly run when the Makefile is interpreted because
#       there is an explicit include Makefile.env directive in the ancestor
#       Makefile.
#       This target must be defined here to ensure the Makefile.env file is
#       created in the right place, that is in the instance directory.
Makefile.env:
	@. scripts/Makefile.env.sh

# NOTE: target variable defined for the build and upgrade target. As you will
#       see in the build.sh file, specifying the stage is mandatory here. The
#       end target must exist as an alias on a build stage in the
#       ide.Dockerfile recipe.
build: TARGET_STAGE=end
upgrade: TARGET_STAGE=end
