main() {
  local image_ids_get_cmd
  image_ids_get_cmd="$(
    cat <<EOF
docker image ls -q \
  --filter "label=project=deovim" \
  | sort | uniq
EOF
  )"

  local image_ids
  image_ids=$(eval "${image_ids_get_cmd}")

  if [ -z "${image_ids}" ]; then
    exit 0
  fi

  while read -r image_id; do
    docker image rm -f "${image_id}"
  done <<EOF
${image_ids}
EOF
}

main
