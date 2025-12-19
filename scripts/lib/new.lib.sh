. scripts/lib/instance.sh

get_next_instance_id() {
  local latest_instance_id &&
    latest_instance_id=$(get_latest_instance_id)

  if [ -z "$latest_instance_id" ]; then
    echo 0
  else
    echo $((latest_instance_id + 1))
  fi
}

create_staging_directory() {
  local hint_instance_id="$1"
  local instance_type="$2"

  local instance_id

  if [ -n "$hint_instance_id" ]; then
    instance_id=$hint_instance_id
  else
    instance_id="$(get_next_instance_id)"
  fi

  mkdir -p instances/staging/"$instance_id"

  echo "$instance_id" "$instance_type"
}

copy_type_to_staging_directory() {
  local instance_id &&
    local instance_type &&
    read -r instance_id instance_type <<<"$1"

  cp -r types/"$instance_type" instances/staging/"$instance_id"

  echo "$instance_id" "$instance_type"
}

create_ancestor_tree() {
  local instance_id &&
    local instance_type &&
    read -r instance_id instance_type <<<"$1"

  # shellcheck source=/dev/null
  . types/"$instance_type"/metadata

  local ancestor_tree=instances/staging/"$instance_id"/"$instance_type"/ancestor

  while [ -n "$TYPE_ANCESTOR" ]; do
    mkdir -p "$ancestor_tree"
    cp -r types/"$TYPE_ANCESTOR"/* "$ancestor_tree"

    # shellcheck source=/dev/null
    . "$ancestor_tree"/metadata
    ancestor_tree="$ancestor_tree/ancestor"
  done

  echo "$instance_id"
}

commit_staging() {
  local instance_id="$1"

  mv ./instances/staging/"$instance_id" instances

  echo "$instance_id"
}

write_signature() {
  local instance_id="$1"
  local signature="$2"

  local instance_type &&
    instance_type="$(get_instance_type "$instance_id")"

  local builddata_path=instances/$instance_id/$instance_type/builddata

  if [ ! -f "$builddata_path" ]; then
    echo "INSTANCE_SIGNATURE=$signature" >"$builddata_path"
  fi

  # shellcheck source=/dev/null
  . "$builddata_path"

  if [ -n "$INSTANCE_SIGNATURE" ]; then
    sed -E "s/INSTANCE_SIGNATURE=.*/INSTANCE_SIGNATURE=$signature/" \
      -i'' "$builddata_path"
  else
    echo "INSTANCE_SIGNATURE=$signature" >>"$builddata_path"
  fi
}

sign_instance() {
  local instance_id="$1"

  local instance_path &&
    instance_path="$(get_instance_path "$instance_id")" &&
    local signature &&
    signature="$(create_instance_signature "$instance_path")" &&
    write_signature "$instance_id" "$signature" &&
    echo "$instance_id"
}

create_instance() (
  local hint_instance_id &&
    local instance_type &&
    IFS=, read -r hint_instance_id instance_type <<<"$1"

  # shellcheck disable=SC2329
  local_decl() {
    local instance_id &&
      instance_id="$1"
    local id &&
      id="$2"

    echo "local ${instance_id} && ${instance_id}=${id};"
  }

  # NOTE: create the instance and expose instance_id as a local variable that
  #       is forwarded to the caller. Avoid globals.
  eval "$(
    create_staging_directory "$hint_instance_id" "$instance_type" |
      transform_first copy_type_to_staging_directory |
      transform_first create_ancestor_tree |
      transform_first commit_staging |
      transform_first sign_instance |
      transform_last local_decl instance_id
  )"

  echo "$instance_id" "$instance_type"
)
