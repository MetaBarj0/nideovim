set -o pipefail

. scripts/lib/funcshional.sh

get_type_directories() {
  find ./types -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
}

has_correct_structure() {
  local dir_name=types/"$1"

  [ -f "$dir_name"/metadata ] &&
    [ -f "$dir_name"/Makefile ]
}

print_type_name() {
  local dir_name="$1"

  echo "  - $dir_name"
}

print_type_info() {
  local dir_name="$1"

  # shellcheck source=/dev/null
  . types/"$dir_name"/metadata

  printf '+'
  printf '%0.s-' $(seq 1 $((${#dir_name} + 2)))
  echo '+'
  printf "| %s |\n" "$dir_name"
  printf '+'
  printf '%0.s-' $(seq 1 $((${#dir_name} + 2)))
  echo '+'
  echo
  echo "$TYPE_INFO"
  echo
}

present_type_names() {
  get_type_directories |
    pstart |
    pthen filter has_correct_structure |
    pthen transform print_type_name |
    pend
}

present_types() {
  get_type_directories |
    pstart |
    pthen filter has_correct_structure |
    pthen transform print_type_info |
    pend
}

is_valid_type() {
  if has_correct_structure "$1"; then
    # shellcheck source=/dev/null
    . ./types/"$1"/metadata

  fi

  [ -n "$TYPE_INFO" ]
}
