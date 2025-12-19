. scripts/lib/instance.sh

set_default_instance_id() {
  local instance_id=$1

  . instances/metadata

  if [ -z "$DEFAULT_INSTANCE_ID" ]; then
    echo "DEFAULT_INSTANCE_ID=$instance_id" >instances/metadata

    return
  fi

  sed -E "s/DEFAULT_INSTANCE_ID=.*/DEFAULT_INSTANCE_ID=$instance_id/" \
    -i'' instances/metadata
}

main() {
  local instance_id
  while ! is_instance_id_valid "$instance_id"; do
    present_instances &&
      read -e -r \
        -p $'\nEnter the identifier of the new default instance: ' \
        instance_id
  done

  set_default_instance_id "$instance_id"
}

main
