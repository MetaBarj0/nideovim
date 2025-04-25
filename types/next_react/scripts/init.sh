# NOTE: exposes useful functions for instance manipulation and info gathering
. "${ROOT_DIR}"/scripts/lib/instance.sh

# NOTE: This is a mandatory function to expose for the init process take into
#       account the table of content to be written in the Makefile.env file in
#       your instance
output_type_toc_items() {
  echo '# REACT SPECIFICS'
}

# NOTE: This is a mandatory function to expose for the init process take into
#       account the table of content to be written in the Makefile.env file in
#       your instance
output_type_section_items() {
  cat <<EOF
################################################################################
# REACT SPECIFICS
################################################################################

$(write_create_next_app_major_version_description | comment)
CREATE_NEXT_APP_MAJOR_VERSION ?= ${CREATE_NEXT_APP_MAJOR_VERSION}

$(write_react_dev_port_description | comment)
REACT_DEV_PORT ?= ${REACT_DEV_PORT}

EOF
}

# NOTE: This is a mandatory function to expose for the init process take into
#       account the table of content to be written in the Makefile.env file in
#       your instance
interactive_init_type_sections() {
  prompt_create_next_app_major_version_description &&
    prompt_react_dev_port_description
}

write_create_next_app_major_version_description() {
  cat <<EOF
The major version of the npm package 'create-next-app' to use. The package
that will be isntalled in this docker image will be the last of this major
version.
default: $(get_default_value_for CREATE_NEXT_APP_MAJOR_VERSION)
EOF
}

write_react_dev_port_description() {
  cat <<EOF
The port to use for local development endeavors for your react application.
This port will be published and reachable from your docker host.
default: $(get_default_value_for REACT_DEV_PORT)
EOF
}

prompt_create_next_app_major_version_description() {
  write_create_next_app_major_version_description
  echo

  read -e -r -p "[${CREATE_NEXT_APP_MAJOR_VERSION}]: " create_next_app_major_version

  if [ -n "${create_next_app_major_version}" ]; then
    CREATE_NEXT_APP_MAJOR_VERSION="${create_next_app_major_version}"
  fi

  echo
}

prompt_react_dev_port_description() {
  write_react_dev_port_description
  echo

  read -e -r -p "[${REACT_DEV_PORT}]: " react_dev_port

  if [ -n "${react_dev_port}" ]; then
    REACT_DEV_PORT="${react_dev_port}"
  fi

  echo
}
