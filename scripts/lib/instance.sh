. scripts/lib/funcshional.sh
. scripts/lib/type.sh

is_instance_id_valid() {
  local id=$1

  [ -n "$id" ] && [ -d "instances/$id" ]
}

report_no_instance_then_exit() {
  echo 'No instance found. Run make new to create one.' >&2

  exit 1
}

get_instance_directories() {
  find instances/ \
    -maxdepth 1 -mindepth 1 \
    -type d \
    -exec basename {} \; |
    grep -E '^[0-9]+$' |
    sort -n
}

get_instance_type() {
  local instance_id=$1

  local type_in_instance &&
    type_in_instance=$(
      find instances/"$instance_id" -maxdepth 1 -mindepth 1 -exec basename {} \;
    )

  echo "$type_in_instance"
}

is_not_instance_id() {
  [ -z "$DEFAULT_INSTANCE_ID" ] || [ "$1" -ne "$DEFAULT_INSTANCE_ID" ]
}

print_instance_info() {
  local instance_id=$1

  local instance_type &&
    instance_type=$(get_instance_type "$instance_id")

  local project_name &&
    project_name=$(get_instance_name "$instance_id" "$instance_type")

  local prefix='| '
  if [ -n "$DEFAULT_INSTANCE_ID" ] &&
    [ "$instance_id" -eq "$DEFAULT_INSTANCE_ID" ]; then
    prefix='->'
  fi

  local longest_type_name &&
    longest_type_name="$(get_longest_type_name)"

  printf "%-2s id: %s type: %-${longest_type_name}s name: %s\n" \
    "$prefix" "$instance_id" "$instance_type" "$project_name"
}

get_instance_name() {
  local instance_id="$1"
  local instance_type="$2"

  mkdir -p instances/staging

  cat <<EOF >instances/staging/Makefile
include instances/$instance_id/$instance_type/Makefile.env

all:
	@echo \$(PROJECT_NAME)
EOF

  make --no-print-directory -f instances/staging/Makefile

  rm instances/staging/Makefile
}

present_instances() {
  local all_instances_info &&
    all_instances_info=$(get_instance_directories |
      any_else report_no_instance_then_exit |
      filter is_not_instance_id |
      push_front "$DEFAULT_INSTANCE_ID" |
      transform print_instance_info) || exit $?

  while read -r -e instance_info; do
    echo "$instance_info"
  done <<<"$all_instances_info"
}

try_get_default_instance_id() {
  if [ -f instances/metadata ]; then
    # shellcheck source=/dev/null
    . instances/metadata
  fi
}
