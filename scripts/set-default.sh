set -o pipefail

. scripts/lib/instance.sh

set_default_instance_id() {
  local instance_id=$1

  if [ ! -f "instances/metadata" ]; then
    echo "DEFAULT_INSTANCE_ID=$instance_id" >instances/metadata

    return
  fi

  if [ -z "$DEFAULT_INSTANCE_ID" ]; then
    echo "DEFAULT_INSTANCE_ID=$instance_id" >>instances/metadata

    return
  fi

  sed -E "s/DEFAULT_INSTANCE_ID=.*/DEFAULT_INSTANCE_ID=$instance_id/" \
    -i'' instances/metadata
}

ask_for_new_default_instance() {
  local instance_id
  while ! is_instance_id_valid "$instance_id"; do
    read -e -r \
      -p $'\nEnter the identifier of the new default instance: ' \
      -i "$DEFAULT_INSTANCE_ID" \
      instance_id
  done

  set_default_instance_id "$instance_id"
}

main() {
  try_get_default_instance_id &&
    present_instances &&
    ask_for_new_default_instance
}

main
