# shellcheck source=lib/compose.lib.sh
. scripts/lib/compose.lib.sh
. "$ROOT_DIR"/scripts/lib/instance.sh

up() {
  docker compose \
    -f "$(get_type_dir_from_current_ancestor_dir)"/docker/compose.yaml up \
    --detach
}

main() {
  export_variables_for_compose &&
    up
}

main
