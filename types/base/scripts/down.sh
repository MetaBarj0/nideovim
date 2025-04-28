# shellcheck source=lib/compose.sh
. scripts/lib/compose.sh
. "$ROOT_DIR"/scripts/lib/instance.sh

export_variables() {
  export_compose_project_name &&
    export_user_info
}

shutdown_project() {
  local type_dir &&
    type_dir="$(get_type_dir_from_current_ancestor_dir)"

  if [ "${DOWN_REMOVES_VOLUMES}" = "yes" ]; then
    docker compose \
      -f "$type_dir"/docker/compose.yaml down \
      --volumes
  else
    docker compose \
      -f "$type_dir"/docker/compose.yaml \
      down
  fi
}

main() {
  export_variables &&
    shutdown_project
}

main
