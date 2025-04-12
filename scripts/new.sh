present_types() {
  find ./types -mindepth 1 -maxdepth 1 -type d -exec basename {} \; |
    sed -e 's/^/  - /'
}

is_valid_type() {
  [ -n "$1" ] && [ -d "./types/$1" ]
}

ask_type() {
  echo First, declare the type of your new instance.

  while ! is_valid_type "${CHOSEN_TYPE}"; do
    printf '\nChoose one value among the following list:\n\n'

    present_types

    printf '\nType? '

    read -r CHOSEN_TYPE
  done
}

get_latest_instance_id() {
  find instances \
    -mindepth 1 -maxdepth 1 \
    -type d \
    -exec basename {} \; |
    grep -E '[0-9]+' |
    sort -r |
    head -n 1
}

create_instance_directory() {
  local latest_instance_id &&
    latest_instance_id=$(get_latest_instance_id)

  if [ -z "$latest_instance_id" ]; then
    INSTANCE_ID=0
  else
    INSTANCE_ID=$((latest_instance_id + 1))
  fi

  mkdir -p instances/$INSTANCE_ID
}

copy_type_to_instance_directory() {
  cp -r types/"$CHOSEN_TYPE" instances/$INSTANCE_ID
}

init_instance() {
  cd instances/$INSTANCE_ID/"$CHOSEN_TYPE" || return $?

  make init
}

create_instance() {
  create_instance_directory &&
    copy_type_to_instance_directory &&
    init_instance
}

main() {
  printf 'Creating new instance...\n\n'

  ask_type && create_instance
}

main
