. scripts/lib/type.sh
. scripts/lib/instance.sh
. scripts/lib/new.lib.sh
. scripts/lib/funcshional.sh

ask_instance_type() {
  local chosen_type &&
    while ! is_valid_type "${chosen_type}"; do
      read -e -r \
        -p "
Choose the type of the instance to create among the following list:
$(present_type_names)

Type? " \
        chosen_type
    done &&
    echo "$chosen_type"
}

set_or_propose_default_instance() {
  # shellcheck source=/dev/null
  . instances/metadata

  if [ -z "$DEFAULT_INSTANCE_ID" ]; then
    echo "DEFAULT_INSTANCE_ID=$(get_latest_instance_id)" >instances/metadata
    return
  fi

  printf '\n\n Would you like to set this instance as default instance?\n\n[y/n]? '

  local yes_or_no

  while read -e -r yes_or_no; do

    if [ "$yes_or_no" = 'y' ] ||
      [ "$yes_or_no" = 'Y' ]; then
      echo "DEFAULT_INSTANCE_ID=$(get_latest_instance_id)" >instances/metadata
      break
    fi

    if [ "$yes_or_no" = 'n' ] ||
      [ "$yes_or_no" = 'N' ]; then
      echo
      break
    fi

    printf '\n[y/n]? '
  done

  echo
}

init_instance() {
  local instance_id="$1"
  local instance_type="$2"

  export DEFAULT_INSTANCE_ID=$instance_id
  export CHOSEN_TYPE="$instance_type"
  export FORWARD_FROM_NEW=true

  make --no-print-directory init

  unset DEFAULT_INSTANCE_ID
  unset FORWARD_FROM_NEW
}

clear_staging_directory() {
  rm -rf instances/staging
}

main() {
  # NOTE: Preparing local variables for future io in init_instance
  eval "$(
    clear_staging_directory &&
      ask_instance_type |
      rtransform create_instance '' |
        to_var instance_id instance_type
  )" &&
    init_instance "$instance_id" "$instance_type" &&
    set_or_propose_default_instance
}

main
