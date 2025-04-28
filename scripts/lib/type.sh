. "$ROOT_DIR"/scripts/lib/funcshional.sh

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
    filter has_correct_structure |
    transform print_type_name
}

present_types() {
  get_type_directories |
    filter has_correct_structure |
    transform print_type_info
}

is_valid_type() {
  if has_correct_structure "$1"; then
    # shellcheck source=/dev/null
    . ./types/"$1"/metadata

  fi

  [ -n "$TYPE_INFO" ]
}

create_type_signature() {
  local type_name="$1"

  find types/"$type_name"/ \
    -type f |
    sort |
    xargs md5sum |
    awk '{print $1}' |
    md5sum |
    awk '{print $1}'
}
