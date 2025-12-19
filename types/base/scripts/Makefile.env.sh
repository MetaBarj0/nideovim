main() {
  local instance_dir &&
    instance_dir="$(basename "$(pwd)")" &&
    [ "$instance_dir" = "ancestor" ] &&
    instance_dir=.. ||
    instance_dir=.

  # NOTE: Argument passing does not work well with `.`, thus invoking bash -c ...
  bash -c ". $instance_dir/scripts/init.sh --defaults"
}

main
