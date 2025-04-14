if [ "${down_removes_volumes}" = "yes" ]; then
  docker compose -f docker.d/compose.yaml down --volumes
else
  docker compose -f docker.d/compose.yaml down
fi
