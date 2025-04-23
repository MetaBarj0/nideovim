# NOTE: If you just want to inherit from the base type behavior regarding the
#       Makefile.env generation (recommended), you will have to copy this file
#       as is in your type
main() {
  if [ -d ancestor ]; then
    cd ancestor || return $?

    # shellcheck source=/dev/null
    . scripts/Makefile.env.sh
  fi
}

main
