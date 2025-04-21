set -o pipefail

. scripts/lib/funcshional.sh
. scripts/lib/type.sh

is_instance_id_valid() {
  local id=$1

  [ -n "$id" ] && [ -d "instances/$id" ]
}

report_no_instance_error() {
  echo 'No instance found. Run make new to create one.' >&2

  return 1
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

is_not_default_instance_id() {
  [ -z "$DEFAULT_INSTANCE_ID" ] || [ "$1" -ne "$DEFAULT_INSTANCE_ID" ]
}

get_longest_instance_type_name() {
  find instances/* -maxdepth 1 -mindepth 1 -type d -exec basename {} \; |
    awk '{print length}' |
    sort -nr |
    head -n1
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
    longest_type_name="$(get_longest_instance_type_name)"

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
  try_get_default_instance_id &&
    get_instance_directories |
    pstart |
      pthen any_else report_no_instance_error |
      pthen filter is_not_default_instance_id |
      pthen push_front "$DEFAULT_INSTANCE_ID" |
      pthen transform print_instance_info |
      pend
}

sanitize_metadata_if_applicable() {
  if [ ! -d "instances/$DEFAULT_INSTANCE_ID" ]; then
    unset DEFAULT_INSTANCE_ID

    sed -E "/DEFAULT_INSTANCE_ID=.*/d" \
      -i'' instances/metadata
  fi
}

try_get_default_instance_id() {
  if [ -f instances/metadata ]; then
    # shellcheck source=/dev/null
    . instances/metadata
  fi

  sanitize_metadata_if_applicable
}
