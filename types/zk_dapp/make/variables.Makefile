# NOTE: Mandatory variable. Used in the ancestor type init.sh script. It is set
#       to the absolute path of the type directory within your instance.
TYPE_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

include Makefile.env

# NOTE: Mandatory. Exporting variables make them reachable in invoked scripts
#       later on.
export
