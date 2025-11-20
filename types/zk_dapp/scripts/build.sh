. "$ROOT_DIR"/scripts/lib/build.sh

# NOTE: A simple build here as ancestor is built beforehand.
main() {
  docker build \
    --build-arg BASE_IMAGE="${INSTANCE_ID}_${PROJECT_NAME}_ide_image" \
    --build-arg USER_HOME_DIR="$(get_user_home_dir)" \
    --build-arg USER_NAME="$(get_user_name)" \
    --target="${TARGET_STAGE?}" \
    -t "${INSTANCE_ID}_${PROJECT_NAME}"_ide_image \
    -f docker/ide/ide.Dockerfile \
    docker/ide
}

main
