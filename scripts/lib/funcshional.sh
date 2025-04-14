push_front() {
  if [ -n "$1" ]; then
    echo "$1"
  fi

  while read -e -r line; do
    echo "$line"
  done
}

filter() {
  local predicate="$1"

  while read -e -r item; do
    if eval "$predicate $item"; then
      echo "$item"
    fi
  done
}

transform() {
  local transformer=$1

  while read -e -r item; do
    eval "$transformer" "$item"
  done
}

any_else() {
  local handler="$1"

  while read -e -r line; do
    unset handler
    echo "$line"
  done

  eval "$handler"
}
