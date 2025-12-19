. scripts/lib/instance.sh

get_instance_help() {
  local instance_id="$1"

  local instance_type &&
    instance_type="$(get_instance_type "$instance_id")"

  # TODO: make -C instead of changing directory everywhere
  make -C instances/"$instance_id"/"$instance_type" --no-print-directory help
}

ask_instance_to_interact_with() {
  try_get_default_instance_id

  local instance_id
  while ! is_instance_id_valid "$instance_id"; do
    echo
    read -e -r \
      -p "Which instance id do you want to see the help? " \
      -i "$DEFAULT_INSTANCE_ID" \
      instance_id
  done

  get_instance_help "$instance_id"
}

main() {
  present_instances &&
    ask_instance_to_interact_with
}

main
