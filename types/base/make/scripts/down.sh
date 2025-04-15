if [ "${down_removes_volumes}" = "yes" ]; then
  docker compose -f docker/compose.yaml down --volumes
else
  docker compose -f docker/compose.yaml down
fi
