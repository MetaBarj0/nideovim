. "${ROOT_DIR}"/scripts/lib/funcshional.sh

get_type_dir() {
  local type_dir="$TYPE_DIR"

  while [ "$(basename "$type_dir")" = "ancestor" ]; do
    cd "$type_dir"/.. || return $?
    type_dir="$(pwd)"
  done

  echo "$type_dir"
}

load_ancestor_tree_defaults() {
  local type_dir="$1"

  while [ -d "$type_dir/ancestor" ]; do
    # shellcheck source=/dev/null
    . "$type_dir"/ancestor/scripts/defaults.sh

    type_dir="$type_dir/ancestor"
  done
}

load_default_values() {
  if [ -n "$TYPE_DIR" ]; then
    local type_dir &&
      type_dir="$(get_type_dir)"

    # shellcheck source=/dev/null
    . "$type_dir"/scripts/defaults.sh

    load_ancestor_tree_defaults "$type_dir"
  else
    # shellcheck source=/dev/null
    . scripts/defaults.sh
  fi
}

write_type_toc_items() {
  if [ "$(type -t output_type_toc_items)" != 'function' ]; then return; fi

  output_type_toc_items
}

write_toc() {
  cat <<EOF
################################################################################
# Makefile.env
#
# This file contains several environment variable definitions.
# Those variables are useful to build and run this debian-based, dockerized and
# neovim-powered integrated development environment
################################################################################

################################################################################
# SECTION INDEX
#
# PROJECT PROPERTIES
# IDE TOOLING
# AUTHENTICATION
# AI INTEGRATION
EOF
  write_type_toc_items
  cat <<EOF
#
################################################################################

EOF
}

comment() {
  while read -e -r line; do
    echo "${line}" | sed -E 's/^/# /'
  done
}

write_project_name_description() {
  cat <<EOF
The name you want to give to this project.
Change this variable value when you want to have concurrent projects running
in parallel for whatever reasons.
This variable value is used to name docker images, containers and volumes
associated with this project.
The project name must be unique.
default: nideovim
EOF
}

write_rootless_description() {
  cat <<EOF
Do you want to build and use this project in a pseudo-rootless mode?
Pseudo-rootless mode consists in running an image with a user that is not
\`root\`. Pseudo-rootless means not fully-rootless as the underlying docker
daemon is still running with a very priviledged user (sometime root).
Set this variable to any value but 0 to activate the pseudo rootless mode.
Keep in mind that pseudo-rootless mode does not fit well at all if you use
DockerDesktop or Orbstack. I Did not find out a way to map user and group id
correctly in the pseudo-rootless resulting container.
Thus, if you use docker directly through DockerDesktop or Orbstack, set
ROOTLESS to 0.
Note that pseudo-rootless mode can be activated in Orbstack's virtual
machines if you have docker installed in this virtual machine.
It also fits particularly well when used in a WSL2 distribution provided docker
is installed.
default: 0
EOF
}

write_user_name_description() {
  cat <<EOF
The user name to use when pseudo-rootless mode is used.
default: nideovim
EOF
}

write_user_home_dir_description() {
  cat <<EOF
The home directory of the user created when the pseudo-rootless mode is used.
default: /home/nideovim
EOF
}

# TODO: dynamic default values depending on the type
write_container_hostname_description() {
  cat <<EOF
The hostname to give to the running container of the ide service.
You may be free to set this value up to your heart desire but keep in mind
checks are performed by docker itself thus, if you choose something too exotic,
the behavior might be undefined.
default: nIDEovim
EOF
}

write_project_properties() {
  cat <<EOF
################################################################################
# PROJECT PROPERTIES
################################################################################

$(write_project_name_description | comment)
PROJECT_NAME ?= ${PROJECT_NAME}

$(write_rootless_description | comment)
ROOTLESS ?= ${ROOTLESS}

$(write_user_name_description | comment)
NON_ROOT_USER_NAME ?= ${NON_ROOT_USER_NAME}

$(write_user_home_dir_description | comment)
NON_ROOT_USER_HOME_DIR ?= ${NON_ROOT_USER_HOME_DIR}

$(write_container_hostname_description | comment)
CONTAINER_HOSTNAME ?= ${CONTAINER_HOSTNAME}

EOF
}

write_llvm_version_description() {
  cat <<EOF
The version of the LLVM to install in the ide service docker image.
If you specify an incorrect value, the build may fail.
Note that the current stable version of the LLVM project may be higher that
the default proposed version number.
default: 20
EOF
}

write_nodejs_version_description() {
  cat <<EOF
In the ide service, the Node.js version to install. Feel free to update it
when new releases are available.
Specifying the special 'latest' value will provide you with the latest
available release. Otherwise you have to set a valid semver compliant
version, for instance 22.4.0. incorrect or not found version will install the
latest one.
default: latest
EOF
}

write_volume_dir_name_description() {
  cat <<EOF
Name of the directory within the user home directory of the ide service
container. This is the target of the volume in which you can store everything
you need.
default: workspace
EOF
}

write_ide_tooling() {
  cat <<EOF
################################################################################
# IDE TOOLING
################################################################################

$(write_llvm_version_description | comment)
LLVM_VERSION ?= ${LLVM_VERSION}

$(write_nodejs_version_description | comment)
NODEJS_VERSION ?= ${NODEJS_VERSION}

$(write_volume_dir_name_description | comment)
VOLUME_DIR_NAME ?= ${VOLUME_DIR_NAME}

EOF
}

write_ssh_public_key_file_description() {
  cat <<EOF
File path of the public key for ssh authentication. Keep in mind that it MUST
target a file on the docker host machine. It is especially important when
your want to run nideovim within another nideovim.
default: ~/.ssh/id_rsa.pub
EOF
}

write_ssh_secret_key_file_description() {
  cat <<EOF
File path of the secret key for ssh authentication. Keep in mind that it MUST
target a file on the docker host machine. It is especially important when
your want to run nideovim within another nideovim.
default: ~/.ssh/id_rsa
EOF
}

write_authentication() {
  cat <<EOF
################################################################################
# AUTHENTICATION
################################################################################

$(write_ssh_public_key_file_description | comment)
SSH_PUBLIC_KEY_FILE ?= ${SSH_PUBLIC_KEY_FILE}

$(write_ssh_secret_key_file_description | comment)
SSH_SECRET_KEY_FILE ?= ${SSH_SECRET_KEY_FILE}

EOF
}

write_anthropic_api_key_description() {
  cat <<EOF
Your anthropic API key to integrate your neovim workflow with Claude thanks
to the Claude plugin (https://github.com/pasky/claude.vim)
You will need to explicitely setup an API key here.
Keep in mind it is a sensitive information (you may deal with real money).
default: not_set
EOF
}

write_ai_integration() {
  cat <<EOF
################################################################################
# AI INTEGRATION
################################################################################

$(write_anthropic_api_key_description | comment)
ANTHROPIC_API_KEY ?= ${ANTHROPIC_API_KEY}

EOF
}

write_type_section_items() {
  if [ "$(type -t output_type_section_items)" != 'function' ]; then return; fi

  output_type_section_items
}

get_output_file_path() {
  local output_file_path=Makefile.env

  while [ "$(basename "$(pwd)")" = 'ancestor' ]; do
    cd ..

    output_file_path="../$output_file_path"
  done

  echo "$output_file_path"
}

write_env_file() {
  local output_file_path &&
    output_file_path="$(get_output_file_path)" &&
    write_toc |
    pstart |
      pthen write_project_properties |
      pthen write_ide_tooling |
      pthen write_authentication |
      pthen write_ai_integration |
      pthen write_type_section_items |
      pend >"$output_file_path"
}

prompt_project_name() {
  write_project_name_description
  echo

  read -e -r -p "[${PROJECT_NAME}]: " project_name

  if [ -n "${project_name}" ]; then
    PROJECT_NAME="${project_name}"
  fi

  echo
}

prompt_rootless_mode() {
  write_rootless_description
  echo

  read -e -r -p "[${ROOTLESS}]: " rootless

  if [ -n "${rootless}" ]; then
    ROOTLESS="${rootless}"
  fi

  echo
}

prompt_non_root_user_name() {
  write_user_name_description
  echo

  read -e -r -p "[${NON_ROOT_USER_NAME}]: " non_root_user_name

  if [ -n "${non_root_user_name}" ]; then
    NON_ROOT_USER_NAME="${non_root_user_name}"
  fi

  echo
}

prompt_non_root_user_directory() {
  write_user_home_dir_description
  echo

  read -e -r -p "[${NON_ROOT_USER_HOME_DIR}]: " non_root_user_home_dir

  if [ -n "${non_root_user_home_dir}" ]; then
    NON_ROOT_USER_HOME_DIR="${non_root_user_home_dir}"
  fi

  echo
}

prompt_container_hostname() {
  write_container_hostname_description
  echo

  read -e -r -p "[${CONTAINER_HOSTNAME}]: " container_hostname

  if [ -n "${container_hostname}" ]; then
    CONTAINER_HOSTNAME="${container_hostname}"
  fi

  echo
}

prompt_project_properties() {
  prompt_project_name &&
    prompt_rootless_mode &&
    prompt_non_root_user_name &&
    prompt_non_root_user_directory &&
    prompt_container_hostname
}

prompt_llvm_version() {
  write_llvm_version_description
  echo

  read -e -r -p "[${LLVM_VERSION}]: " llvm_version

  if [ -n "${llvm_version}" ]; then
    LLVM_VERSION="${llvm_version}"
  fi

  echo
}

prompt_nodejs_version() {
  write_nodejs_version_description
  echo

  read -e -r -p "[${NODEJS_VERSION}]: " nodejs_version

  if [ -n "${nodejs_version}" ]; then
    NODEJS_VERSION="${nodejs_version}"
  fi

  echo
}

prompt_volume_dir_name() {
  write_volume_dir_name_description
  echo

  read -e -r -p "[${VOLUME_DIR_NAME}]: " volume_dir_name

  if [ -n "${volume_dir_name}" ]; then
    VOLUME_DIR_NAME="${volume_dir_name}"
  fi

  echo
}

prompt_ide_tooling() {
  prompt_llvm_version &&
    prompt_nodejs_version &&
    prompt_volume_dir_name
}

prompt_ssh_public_key() {
  write_ssh_public_key_file_description
  echo

  read -e -r -p "[${SSH_PUBLIC_KEY_FILE}]: " ssh_public_key_file

  if [ -n "${ssh_public_key_file}" ]; then
    SSH_PUBLIC_KEY_FILE="${ssh_public_key_file}"
  fi

  echo
}

prompt_ssh_secret_key() {
  write_ssh_secret_key_file_description
  echo

  read -e -r -p "[${SSH_SECRET_KEY_FILE}]: " ssh_secret_key_file

  if [ -n "${ssh_secret_key_file}" ]; then
    SSH_SECRET_KEY_FILE="${ssh_secret_key_file}"
  fi

  echo
}

prompt_authentication() {
  prompt_ssh_public_key &&
    prompt_ssh_secret_key
}

prompt_anthropic_api_key() {
  write_anthropic_api_key_description
  echo

  read -e -r -p "[${ANTHROPIC_API_KEY}]: " anthropic_api_key

  if [ -n "${anthropic_api_key}" ]; then
    ANTHROPIC_API_KEY="${anthropic_api_key}"
  fi

  echo
}

prompt_ai_integration() {
  prompt_anthropic_api_key
}

prompt_type_sections() {
  if [ "$(type -t interactive_init_type_sections)" != 'function' ]; then return; fi

  interactive_init_type_sections
}

init_interactive() {
  prompt_project_properties &&
    prompt_ide_tooling &&
    prompt_authentication &&
    prompt_ai_integration &&
    prompt_type_sections &&
    write_env_file
}

init() {
  local default_flag="$1"

  load_default_values

  if [ "$default_flag" = '--defaults' ]; then
    write_env_file
  else
    init_interactive
  fi
}

handle_int_signal() {
  write_env_file &&
    exit $?

}

setup_signal_handling() {
  trap handle_int_signal INT
}

source_type_functions() {
  if [ -z "$TYPE_DIR" ]; then return; fi

  # shellcheck source=/dev/null
  . "$TYPE_DIR"/scripts/init.sh
}

main() {
  local default_flag="$1"

  setup_signal_handling &&
    source_type_functions &&
    init "$default_flag"
}

main "$@"
