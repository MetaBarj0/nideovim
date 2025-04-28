# shellcheck source=lib/compose.sh
. scripts/lib/compose.sh
. "$ROOT_DIR"/scripts/lib/instance.sh

export_variables() {
  export_compose_project_name &&
    export_user_info
}

main() {
  export_variables &&
    docker compose \
      -f "$(get_type_dir_from_current_ancestor_dir)"/docker/compose.yaml \
      config
}

main
