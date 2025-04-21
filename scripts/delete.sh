set -o pipefail

. scripts/lib/instance.sh
. scripts/lib/funcshional.sh

format_list() {
  while read -r -e repository; do
    echo "  - $repository"
  done
}

ensure_instance_has_no_image_left() {
  local instance_id=$1
  local project_name=$2

  local image_list &&
    image_list="$(
      docker image ls \
        --format "id: {{.ID}}\trepository: {{.Repository}}" \
        --filter "label=instance-id=${instance_id}" \
        --filter "label=project-name=${project_name}"
    )"

  if [ -n "$image_list" ]; then
    echo "Cannot delete the following instance:"
    echo "  - instance id: ${instance_id}"
    echo "  - project name: ${project_name}"
    echo "There are still at least one docker image related to this instance:"
    echo "$image_list" | format_list

    return 1
  fi
}

ensure_instance_has_no_volume_left() {
  local project_name=$2
  local compose_project_name="${1}_${2}"

  local volume_list &&
    volume_list="$(
      docker volume ls \
        --format "volume name: {{.Name}}" \
        --filter "label=com.docker.compose.project=$compose_project_name"
    )"

  if [ -n "$volume_list" ]; then
    echo "Cannot delete the following instance:"
    echo "  - instance id: ${instance_id}"
    echo "  - project name: ${project_name}"
    echo "There are still at least one docker volume related to this instance:"
    echo "$volume_list" | format_list

    return 1
  fi
}

ensure_instance_has_no_artifact_left() {
  local instance_id=$1

  local instance_type &&
    instance_type="$(get_instance_type "$instance_id")"

  local instance_name &&
    instance_name="$(get_instance_name "$instance_id" "$instance_type")"

  ensure_instance_has_no_image_left "$instance_id" "$instance_name" &&
    ensure_instance_has_no_volume_left "$instance_id" "$instance_name"
}

delete_instance() {
  local instance_id=$1

  rm -rf instances/"$instance_id"
}

try_delete_instance() {
  local instance_id=$1

  ensure_instance_has_no_artifact_left "$instance_id" &&
    delete_instance "$instance_id"
}

ask_instance_to_delete() {
  local instance_id
  while ! is_instance_id_valid "$instance_id"; do
    echo
    read -e -r \
      -p "Which instance id do you want to delete? " \
      -i "$DEFAULT_INSTANCE_ID" \
      instance_id
  done

  try_delete_instance "$instance_id"
}

ask_new_default_instance_if_applicable() {
  if [ "$(get_instance_directories | count)" -eq 0 ]; then
    return
  fi

  (
    unset -f main
    . scripts/set-default.sh
  )
}

main() {
  present_instances &&
    ask_instance_to_delete &&
    ask_new_default_instance_if_applicable
}

main
