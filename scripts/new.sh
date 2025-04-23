. scripts/lib/type.sh

ask_type() {
  echo First, declare the type of your new instance.

  while ! is_valid_type "${CHOSEN_TYPE}"; do
    printf '\nChoose one value among the following list:\n\n'

    present_type_names

    echo
    read -e -r \
      -p 'Type? ' \
      CHOSEN_TYPE
  done
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

create_staging_directory() {
  local latest_instance_id &&
    latest_instance_id=$(get_latest_instance_id)

  if [ -z "$latest_instance_id" ]; then
    INSTANCE_ID=0
  else
    INSTANCE_ID=$((latest_instance_id + 1))
  fi

  mkdir -p instances/staging/$INSTANCE_ID
}

copy_type_to_staging_directory() {
  cp -r types/"$CHOSEN_TYPE" instances/staging/$INSTANCE_ID
}

copy_ancestor_type_if_applicable() {
  # shellcheck source=/dev/null
  . types/"$CHOSEN_TYPE"/metadata

  if [ -z "$TYPE_ANCESTOR" ]; then
    return
  fi

  mkdir -p instances/staging/$INSTANCE_ID/"$CHOSEN_TYPE"/ancestor
  cp -r types/"$TYPE_ANCESTOR"/* instances/staging/$INSTANCE_ID/"$CHOSEN_TYPE"/ancestor
}

init_instance() {
  export DEFAULT_INSTANCE_ID=$INSTANCE_ID
  export CHOSEN_TYPE
  export FORWARD_FROM_NEW=true

  make --no-print-directory init

  unset DEFAULT_INSTANCE_ID
  unset FORWARD_FROM_NEW
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

commit_staging() {
  mv ./instances/staging/$INSTANCE_ID instances
}

create_instance() {
  create_staging_directory &&
    copy_type_to_staging_directory &&
    copy_ancestor_type_if_applicable &&
    commit_staging &&
    init_instance
}

clear_staging_directory() {
  rm -rf instances/staging
}

clear_staging_directory_and_exit() {
  clear_staging_directory

  exit 1
}

main() {
  trap clear_staging_directory_and_exit INT

  printf 'Creating new instance...\n\n'

  clear_staging_directory &&
    ask_type &&
    create_instance &&
    set_or_propose_default_instance
}

main
