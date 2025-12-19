init_funcshionnal() {
  git submodule update \
    --init --recursive \
    "${ROOT_DIR}"/scripts/lib/funcshional \
    >/dev/null 2>&1

  export FUNCSHIONAL_ROOT_DIR="$ROOT_DIR"/scripts/lib/funcshional/

  # shellcheck source=/dev/null
  . "$FUNCSHIONAL_ROOT_DIR"/src/funcshional.sh
}

init_dependencies() {
  init_funcshionnal
}
