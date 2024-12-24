export_project_name() {
  export COMPOSE_PROJECT_NAME
}

export_user_home_dir() {
  if [ "${ROOTLESS}" -eq 0 ]; then
    export USER_HOME_DIR=/root
  else
    export USER_HOME_DIR="${NON_ROOT_USER_HOME_DIR}"
  fi
}

export_variables() {
  export_project_name &&
    export_user_home_dir
}

main() {
  export_variables &&
    docker compose -f docker.d/compose.yaml up --detach
}

main
