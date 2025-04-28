. scripts/lib/instance.sh
. scripts/lib/funcshional.sh
. scripts/lib/new.lib.sh

is_instance_outdated() {
  local instance_id="$1"

  [ "outdated" = "$(get_instance_status "$instance_id")" ]
}

report_error_instance_up_to_date() {
  echo 'echo Nothing to migrate, the instance is up to date && exit 1'

  return 1
}

backup_runtime_files_in_staging() {
  local instance_id="$1"
  local instance_type &&
    instance_type="$(get_instance_type "$instance_id")"

  mkdir -p instances/staging/migrate/"$instance_id" &&
    cp instances/"$instance_id"/"$instance_type"/Makefile.env \
      instances/"$instance_id"/"$instance_type"/builddata \
      instances/staging/migrate/"$instance_id"

  echo "$instance_id" "$instance_type"
}

delete_instance_files() {
  local instance_id="$1"
  local instance_type="$2"

  rm -rf instances/"$instance_id"

  echo "$instance_id" "$instance_type"
}

restore_runtime_files_from_staging() {
  local instance_id="$1"
  local instance_type="$2"

  cp instances/staging/migrate/"$instance_id"/Makefile.env \
    instances/staging/migrate/"$instance_id"/builddata \
    instances/"$instance_id"/"$instance_type"

  echo "$instance_id" "$instance_type"
}

clear_staging() {
  local instance_id="$1"
  local instance_type="$2"

  rm -rf instances/staging/migrate/"$instance_id"

  echo "$instance_type"
}

is_no() {
  local input="$1"

  [ "$input" = 'n' ] ||
    [ "$input" = 'N' ]
}

is_yes_or_no() {
  local input="$1"

  [ "$input" = 'y' ] ||
    [ "$input" = 'Y' ] ||
    is_no "$input"
}

ask_for_instance_action() {
  local action="$1"
  local yes_or_no=

  while ! is_yes_or_no "$yes_or_no"; do
    read -e -r \
      -p "Would you like to $action the migrated instance (recommended)? [y/n]: " \
      -i 'y' \
      yes_or_no
  done

  if is_no "$yes_or_no"; then
    return 1
  fi
}

ask_for_instance_init() {
  local instance_id="$1"

  if ask_for_instance_action init; then
    export HINT_INSTANCE_ID="$instance_id"

    make --no-print-directory init

    unset HINT_INSTANCE_ID
  fi
}

ask_for_instance_build() {
  local instance_id="$1"
  local instance_type="$2"

  if ask_for_instance_action build; then
    export HINT_INSTANCE_ID="$instance_id"

    make --no-print-directory build

    unset HINT_INSTANCE_ID
  fi
}

migrate_instance() {
  local instance_id="$1"

  eval "$(
    backup_runtime_files_in_staging "$instance_id" |
      transform delete_instance_files |
      transform create_instance |
      transform restore_runtime_files_from_staging |
      transform clear_staging |
      to_var instance_type
  )"

  echo "$instance_id" "$instance_type"
}

clear_staging_directory() {
  rm -rf instances/staging
}

ask_instance_to_migrate() {
  local instance_id &&
    while ! is_instance_id_valid "$instance_id"; do
      read -e -r \
        -p "
Which instance id do you want to migrate?
$(present_instances)

Id? " \
        -i "$HINT_INSTANCE_ID" \
        instance_id
    done &&
    echo "$instance_id"
}

main() {
  # NOTE: evaluate local variables before io
  eval "$(
    clear_staging_directory &&
      ask_instance_to_migrate |
      pstart |
        pthen filter is_instance_outdated |
        pthen any_else report_error_instance_up_to_date |
        pthen transform migrate_instance |
        pthen to_var instance_id instance_type |
        pend
  )" &&
    ask_for_instance_init "$instance_id" &&
    ask_for_instance_build "$instance_id" "$instance_type"
}

main
