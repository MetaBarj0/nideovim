main() {
  cd instances/"$DEFAULT_INSTANCE_ID"/"$CHOSEN_TYPE" || return 1

  make --no-print-directory "$1"

  cd - >/dev/null || return 1
}

# $1: make target to forward
main "$1"
