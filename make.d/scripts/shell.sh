container_is_running() {
  local container_id &&
    container_id="$(
      docker ps -q --filter Name="${COMPOSE_PROJECT_NAME}"_ide_container
    )"

  [ -n "${container_id}" ]
}

environments_installed() {
  docker exec -it \
    "${COMPOSE_PROJECT_NAME}_ide_container" \
    bash -c '[ -f /root/.environments_installed ]'
}

main() {
  if ! container_is_running; then
    cat <<EOF >&2
${COMPOSE_PROJECT_NAME} ide service container is not running.
Run the ide service by issuing: \`make up\`
Exiting...
EOF

    return 1
  fi

  while ! environments_installed; do
    sleep 1
  done

  docker exec -it "${COMPOSE_PROJECT_NAME}_ide_container" bash
}

main
