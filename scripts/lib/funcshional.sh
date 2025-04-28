# TODO: document this not so trivial lib
set -o pipefail

# TODO: local variable for read instructions
push_front() {
  if [ -n "$1" ]; then
    echo "$1"
  fi

  sink
}

length() {
  while IFS= read -e -r item; do
    printf '%s' "$item" | wc -m
  done
}

filter() {
  local predicate="$1"

  while IFS= read -e -r item; do
    if "$predicate" "$item"; then
      echo "$item"
    fi
  done
}

transform() {
  local f="$1"
  shift

  while IFS= read -e -r item; do
    local array=()
    read -r -a array <<<"$item"

    "$f" "${array[@]}" "$@"
  done
}

rtransform() {
  local f="$1"
  shift

  while IFS= read -e -r item; do
    local array=()
    read -r -a array <<<"$item"

    "$f" "$@" "${array[@]}"
  done
}

sink() {
  transform echo
}

skip() {
  local n="$1"

  while [ -n "$n" ] && [ "$n" -gt 0 ]; do
    IFS= read -e -r
    n=$((n - 1))
  done

  sink
}

any_else() {
  local handler="$1"

  if IFS= read -e -r line; then
    echo "$line"
  else
    "$handler" "$@"
  fi
}

count() {
  local c=0

  while IFS= read -e -r; do
    c=$((c + 1))
  done

  echo $c
}

to_var() {
  while IFS= read -e -r line; do
    local keys &&
      read -e -r -a keys <<<"$@"

    local values &&
      read -e -r -a values <<<"$line"

    if [ ${#keys[@]} -ne ${#values[@]} ]; then
      echo "error in to_var: variable names and values mismatch: \
${keys[*]} <-> ${values[*]}" >&2

      # FIX: A sink may be needed here?

      return 1
    fi

    local i=0
    local result='true'

    while [ $i -lt ${#keys[@]} ]; do
      result="$result && local ${keys[$i]}=\"${values[$i]}\""
      i=$((i + 1))
    done

    echo "$result"
  done
}

pstart() {
  echo 'local pipeline_last_exit_code=0'

  sink
}

_pstage() {
  local from=$1 && shift
  local f="$1" && shift

  local output &&
    output="$("$f" "$@")"

  local exit_code=$?

  if [ $exit_code -ne 0 ]; then
    echo "local pipeline_last_exit_code=$exit_code; \
          local pipeline_error_info=\"$from failure with $f call\""
  else
    echo "local pipeline_last_exit_code=0"
  fi

  sink

  # NOTE: handles empty lines that must not be printed
  if [ -n "$output" ]; then
    echo "$output"
  fi
}

pthen() {
  local pipeline_header=

  IFS= read -e -r pipeline_header

  eval "$pipeline_header"

  # shellcheck disable=SC2154
  if [ "$pipeline_last_exit_code" -ne 0 ]; then
    echo "$pipeline_header"

    sink

    return "$pipeline_last_exit_code"
  fi

  _pstage pthen "$@"
}

pcatch() {
  IFS= read -e -r pipeline_header

  eval "$pipeline_header"

  # shellcheck disable=SC2154
  if [ "$pipeline_last_exit_code" -eq 0 ]; then
    sink

    return 0
  fi

  _pstage pcatch "$@"
}

pend() {
  local pipeline_header=

  IFS= read -e -r pipeline_header

  eval "$pipeline_header"

  sink

  return "$pipeline_last_exit_code"
}
