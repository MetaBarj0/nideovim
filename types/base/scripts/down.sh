# shellcheck source=lib/compose.lib.sh
. scripts/lib/compose.lib.sh
. "$ROOT_DIR"/scripts/lib/instance.sh

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
  export_variables_for_compose &&
    apply_external_custom_compose_override &&
    shutdown_project
}

main
