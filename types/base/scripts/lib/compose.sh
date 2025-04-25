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

get_type_dir_from_ancestor_dir() {
  local type_dir &&
    type_dir="$(pwd)"

  while [ "$(basename "$type_dir")" = 'ancestor' ]; do
    cd "$type_dir"/.. || return $?

    type_dir=$(pwd)

    cd - >/dev/null || return $?
  done

  echo "$type_dir"
}
