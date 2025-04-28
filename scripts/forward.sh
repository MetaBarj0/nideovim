. scripts/lib/instance.sh

forward_from_new() {
  cd instances/"$DEFAULT_INSTANCE_ID"/"$CHOSEN_TYPE" || return 1

  make --no-print-directory "$1"

  cd - >/dev/null || return 1
}

forward_target_to_instance() {
  local target="$1"
  local instance_id="$2"

  local instance_type &&
    instance_type="$(get_instance_type "$instance_id")"

  cd instances/"$instance_id"/"$instance_type" || return 1

  export INSTANCE_ID=$instance_id

  make --no-print-directory "$target"

  cd - >/dev/null || return 1
}

ask_instance_to_interact_with() {
  local target=$1

  local instance_id="$HINT_INSTANCE_ID"
  while ! is_instance_id_valid "$instance_id"; do
    echo
    read -e -r \
      -p "Which instance id do you want to $target? " \
      -i "$DEFAULT_INSTANCE_ID" \
      instance_id
  done

  forward_target_to_instance "$target" "$instance_id"
}

fallback_forward() {
  present_instances &&
    ask_instance_to_interact_with "$1"
}

main() {
  if [ -n "${FORWARD_FROM_NEW+set}" ]; then
    forward_from_new "$1"
  else
    fallback_forward "$1"
  fi
}

# NOTE: $1 is the make target to forward
main "$1"
