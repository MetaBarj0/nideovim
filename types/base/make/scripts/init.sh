# shellcheck source=/dev/null
. "${NIDEOVIM_MAKEFILE_DIR:-.}/make/lib/color.sh"

load_default_values() {
  . ./make/env/Makefile.env.defaults
}

write_toc() {
  cat <<EOF >>Makefile.env
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

write_project_properties() {
  cat <<EOF >>Makefile.env
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
  cat <<EOF >>Makefile.env
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
  cat <<EOF >>Makefile.env
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
  cat <<EOF >>Makefile.env
################################################################################
# AI INTEGRATION
################################################################################

$(write_anthropic_api_key_description | comment)
ANTHROPIC_API_KEY ?= ${ANTHROPIC_API_KEY}

EOF
}

write_env_file() {
  true >Makefile.env &&
    write_toc &&
    write_project_properties &&
    write_ide_tooling &&
    write_authentication &&
    write_ai_integration
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

prompt_project_properties() {
  prompt_project_name &&
    prompt_rootless_mode &&
    prompt_non_root_user_name &&
    prompt_non_root_user_directory
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

init_interactive() {
  prompt_project_properties &&
    prompt_ide_tooling &&
    prompt_authentication &&
    prompt_ai_integration &&
    write_env_file
}

init() {
  load_default_values

  if [ "$1" = '--defaults' ]; then
    write_env_file
  else
    init_interactive
  fi
}

handle_int_signal() {
  set_print_color_default &&
    write_env_file &&
    exit $?

}

setup_signal_handling() {
  trap handle_int_signal INT
}

main() {
  setup_signal_handling &&
    init "$1"
}

main "$@"
