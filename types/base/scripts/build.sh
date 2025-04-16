get_user_gid() {
  if [ "${ROOTLESS}" -eq 0 ]; then
    echo 0
  else
    getent group docker | cut -d : -f 3
  fi
}

get_user_home_dir() {
  if [ "${ROOTLESS}" -eq 0 ]; then
    echo /root
  else
    echo "${NON_ROOT_USER_HOME_DIR}"
  fi
}

get_user_name() {
  if [ "${ROOTLESS}" -eq 0 ]; then
    echo root
  else
    echo "${NON_ROOT_USER_NAME}"
  fi
}

get_user_uid() {
  if [ "${ROOTLESS}" -eq 0 ]; then
    echo 0
  else
    id -u
  fi
}

main() {
  docker build \
    --build-arg CACHE_NONCE="$(date +%s)" \
    --build-arg COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME}" \
    --build-arg LLVM_VERSION="${LLVM_VERSION}" \
    --build-arg NODEJS_VERSION="${NODEJS_VERSION}" \
    --build-arg ROOTLESS="${ROOTLESS}" \
    --build-arg USER_GID="$(get_user_gid)" \
    --build-arg USER_HOME_DIR="$(get_user_home_dir)" \
    --build-arg USER_NAME="$(get_user_name)" \
    --build-arg USER_UID="$(get_user_uid)" \
    --build-arg VOLUME_DIR_NAME="${VOLUME_DIR_NAME}" \
    --target="${TARGET_STAGE?}" \
    -t "${COMPOSE_PROJECT_NAME}"_ide_image \
    -f docker/ide/ide.Dockerfile \
    docker/ide
}

main
