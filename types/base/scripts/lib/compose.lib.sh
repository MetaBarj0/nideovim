export_compose_project_name() {
  export COMPOSE_PROJECT_NAME="${INSTANCE_ID}_${PROJECT_NAME}"
}

export_user_info() {
  if [ "${ROOTLESS}" -eq 0 ]; then
    export USER_HOME_DIR=/root
    export USER_NAME=root
  else
    export USER_HOME_DIR="${NON_ROOT_USER_HOME_DIR}"
    export USER_NAME="${NON_ROOT_USER_NAME}"
  fi
}

export_variables_for_compose() {
  export_compose_project_name &&
    export_user_info
}

touch_external_custom_compose_override_files_for_all_ancestors() {
  local type_dir &&
    type_dir="$(pwd)"

  while [ "$(basename "$type_dir")" = 'ancestor' ]; do
    touch "$type_dir/docker/custom_external_override.yaml"
    cd "$type_dir"/.. || return $?

    type_dir=$(pwd)

    cd - >/dev/null || return $?
  done
}

reset_external_custom_compose_override_file() {
  local compose_dir &&
    compose_dir="$(get_type_dir_from_current_ancestor_dir)/docker"
  true >"${compose_dir}/custom_external_override.yaml"
}

check_external_custom_compose_override_file() {
  if [ -z "${EXTERNAL_CUSTOM_COMPOSE_OVERRIDE_FILE}" ]; then return 0; fi

  if [ ! -f "${EXTERNAL_CUSTOM_COMPOSE_OVERRIDE_FILE}" ] &&
    [ ! -f "${ROOT_DIR}/${EXTERNAL_CUSTOM_COMPOSE_OVERRIDE_FILE}" ]; then
    cat <<EOF >&2
ERROR: ${EXTERNAL_CUSTOM_COMPOSE_OVERRIDE_FILE} file does not exist.
Run 'make init' and ensure the path of the external override compose file is
correctly set.
EOF
    return 1
  fi
}

get_external_custom_compose_override_file() {
  if [ -f "${EXTERNAL_CUSTOM_COMPOSE_OVERRIDE_FILE}" ]; then
    echo "${EXTERNAL_CUSTOM_COMPOSE_OVERRIDE_FILE}"
  else
    echo "${ROOT_DIR}/${EXTERNAL_CUSTOM_COMPOSE_OVERRIDE_FILE}"
  fi
}

sync_external_custom_override_compose_file_into_instance_docker_directory() {
  if [ -z "${EXTERNAL_CUSTOM_COMPOSE_OVERRIDE_FILE}" ]; then return 0; fi

  local external_custom_compose_override_file &&
    external_custom_compose_override_file="$(get_external_custom_compose_override_file)"

  local compose_dir &&
    compose_dir="$(get_type_dir_from_current_ancestor_dir)/docker"

  cp -f \
    "${external_custom_compose_override_file}" \
    "${compose_dir}/custom_external_override.yaml"
}

apply_external_custom_compose_override() {
  touch_external_custom_compose_override_files_for_all_ancestors &&
    reset_external_custom_compose_override_file &&
    check_external_custom_compose_override_file &&
    sync_external_custom_override_compose_file_into_instance_docker_directory
}
