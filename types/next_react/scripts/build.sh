# TODO: this should be provided by the ancestor
get_user_name() {
  if [ "${ROOTLESS}" -eq 0 ]; then
    echo root
  else
    echo "${NON_ROOT_USER_NAME}"
  fi
}

# NOTE: As there are new variables defined in default.sh, a specific build is
#       needed because those variables are used as build arguments.
main() {
  docker build \
    --build-arg BASE_IMAGE="${INSTANCE_ID}_${PROJECT_NAME}_ide_image" \
    --build-arg CREATE_NEXT_APP_MAJOR_VERSION="${CREATE_NEXT_APP_MAJOR_VERSION}" \
    --build-arg USER_NAME="$(get_user_name)" \
    --target="${TARGET_STAGE?}" \
    -t "${INSTANCE_ID}_${PROJECT_NAME}"_ide_image \
    -f docker/ide/ide.Dockerfile \
    docker/ide
}

main
