# shellcheck source=lib/compose.sh
. scripts/lib/compose.sh

export_variables() {
  export_compose_project_name &&
    export_user_info
}

up() {
  docker compose \
    -f "$(get_type_dir_from_ancestor_dir)"/docker/compose.yaml up \
    --detach
}

main() {
  export_variables &&
    up
}

main
