# NOTE: Mandatory variable. Used in the ancestor type init.sh script. It is set
#       to the absolute path of the type directory within your instance.
TYPE_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

# NOTE: Mandatory variable. Used in the ancestor type init.sh script. It is set
# to the absolute path of the ancestor directory in the type directory within
# your instance.
ANCESTOR_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))ancestor

# NOTE: inherit all variables of the ancestor.
include ancestor/make/variables.Makefile

# NOTE: Mandatory. Exporting variables make them reachable in invoked scripts
#       later on.
export
