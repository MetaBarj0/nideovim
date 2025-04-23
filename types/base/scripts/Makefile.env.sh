main() {
  # NOTE: Argument passing does not work well with `.`, thus invoking bash -c ...
  bash -c ". ${ANCESTOR_DIR:-.}/scripts/init.sh --defaults"
}

main "$@"
