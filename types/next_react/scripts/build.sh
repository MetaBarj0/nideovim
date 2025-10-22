. "$ROOT_DIR"/scripts/lib/build.sh

# NOTE: As there are new variables defined in default.sh, a specific build is
#       needed because those variables are used as build arguments.
main() {
  docker build \
    --build-arg BASE_IMAGE="${INSTANCE_ID}_${PROJECT_NAME}_ide_image" \
    --build-arg CREATE_NEXT_APP_MAJOR_VERSION="${CREATE_NEXT_APP_MAJOR_VERSION}" \
    --build-arg USER_HOME_DIR="$(get_user_home_dir)" \
    --build-arg USER_NAME="$(get_user_name)" \
    --target="${TARGET_STAGE?}" \
    -t "${INSTANCE_ID}_${PROJECT_NAME}"_ide_image \
    -f docker/ide/ide.Dockerfile \
    docker/ide
}

main
