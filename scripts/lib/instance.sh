. scripts/lib/funcshional.sh

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
