. "$ROOT_DIR"/scripts/lib/funcshional.sh
. "$ROOT_DIR"/scripts/lib/type.sh

get_instance_type() {
  local instance_id=$1

  local type_in_instance &&
    type_in_instance=$(
      find instances/"$instance_id" -maxdepth 1 -mindepth 1 -exec basename {} \;
    )

  echo "$type_in_instance"
}

is_instance_id_valid() {

  local instance_id=$1

  if [ -z "$instance_id" ]; then return 1; fi
  if [ ! -d "instances/$instance_id" ]; then return 1; fi

  local instance_type &&
    instance_type="$(get_instance_type "$instance_id")"

  if [ ! -f "instances/$instance_id/$instance_type/builddata" ]; then
    return 1
  fi
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

is_not_default_instance_id() {
  [ -z "$DEFAULT_INSTANCE_ID" ] || [ "$1" -ne "$DEFAULT_INSTANCE_ID" ]
}

get_longest_instance_type_name() {
  find instances/* -maxdepth 1 -mindepth 1 -type d -exec basename {} \; |
    awk '{print length}' |
    sort -nr |
    head -n1
}

get_project_name() {
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

output_instance_id_and_type() {
  local instance_id="$1"
  local instance_type &&
    instance_type="$(get_instance_type "$instance_id")"

  echo "$instance_id $instance_type"
}

get_longest_project_name() {
  # NOTE: ensured in a previous pipeline there is at least one instance
  get_instance_directories |
    transform output_instance_id_and_type |
    transform get_project_name |
    length |
    sort -nr |
    head -n 1
}

create_instance_signature() {
  local instance_path="$1"

  find "$instance_path" \
    -type f \
    -not -path '**/ancestor/**' \
    -not -name Makefile.env \
    -not -name builddata |
    sort |
    xargs md5sum |
    awk '{print $1}' |
    md5sum |
    awk '{print $1}'
}

get_instance_path() {
  local instance_id="$1" &&
    local instance_type &&
    instance_type="$(get_instance_type "$instance_id")" &&
    echo "instances/$instance_id/$instance_type"
}

are_all_instance_ancestors_up_to_date() {
  local instance_path="$1"

  while [ -d "$instance_path/ancestor" ]; do
    cd "$instance_path/ancestor" || return $?

    local ancestor_instance_signature &&
      ancestor_instance_signature="$(create_instance_signature .)"

    cd - >/dev/null || return $?

    # shellcheck source=/dev/null
    . "$instance_path/metadata"

    local ancestor_type_signature &&
      ancestor_type_signature="$(create_type_signature "$TYPE_ANCESTOR")"

    if [ "$ancestor_type_signature" != "$ancestor_instance_signature" ]; then
      return 1
    fi

    instance_path="$instance_path/ancestor"
  done
}

is_instance_up_to_date() {
  local instance_id="$1"

  local instance_path &&
    instance_path="$(get_instance_path "$instance_id")"

  local instance_type &&
    instance_type="$(get_instance_type "$instance_id")"

  local type_signature &&
    type_signature="$(create_type_signature "$instance_type")"

  local instance_signature &&
    instance_signature="$(create_instance_signature "$instance_path")"

  [ "$instance_signature" = "$type_signature" ]
}

get_instance_status() {
  local instance_id="$1"
  local instance_path &&
    instance_path="$(get_instance_path "$instance_id")"

  if is_instance_up_to_date "$instance_id" &&
    are_all_instance_ancestors_up_to_date "$instance_path"; then
    echo up to date
  else
    echo outdated
  fi
}

print_instance_info() {
  local instance_id=$1

  local instance_type &&
    instance_type=$(get_instance_type "$instance_id")

  local project_name &&
    project_name=$(get_project_name "$instance_id" "$instance_type")

  local prefix='| '
  if [ -n "$DEFAULT_INSTANCE_ID" ] &&
    [ "$instance_id" -eq "$DEFAULT_INSTANCE_ID" ]; then
    prefix='->'
  fi

  local longest_type_name &&
    longest_type_name="$(get_longest_instance_type_name)"

  local longest_project_name &&
    longest_project_name="$(get_longest_project_name)"

  local instance_status &&
    instance_status="$(get_instance_status "$instance_id")"

  printf "%-2s id: %s \
type: %-${longest_type_name}s \
name: %-${longest_project_name}s \
status: %s\n" \
    "$prefix" "$instance_id" "$instance_type" "$project_name" "$instance_status"
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

present_instances() {
  try_get_default_instance_id &&
    get_instance_directories |
    pstart |
      pthen any_else report_no_instance_error |
      pthen filter is_instance_id_valid |
      pthen any_else report_no_instance_error |
      pthen filter is_not_default_instance_id |
      pthen push_front "$DEFAULT_INSTANCE_ID" |
      pthen transform print_instance_info |
      pend
}

get_type_dir_from_current_ancestor_dir() {
  local type_dir &&
    type_dir="$(pwd)"

  while [ "$(basename "$type_dir")" = 'ancestor' ]; do
    cd "$type_dir"/.. || return $?

    type_dir=$(pwd)

    cd - >/dev/null || return $?
  done

  echo "$type_dir"
}

get_latest_instance_id() {
  find instances \
    -mindepth 1 -maxdepth 1 \
    -type d \
    -exec basename {} \; |
    grep -E '[0-9]+' |
    sort -n -r |
    head -n 1
}
