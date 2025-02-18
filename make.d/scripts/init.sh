. "${NIDEOVIM_MAKEFILE_DIR:-.}/make.d/lib.d/color.sh"

print_init_header() {
  set_print_color_default

  cat <<EOF
========================nideovim initialization facility========================

  Welcome in the initializer facility.

  You'll be asked several questions for you to answer in order to initialize
  all general settings of your nideovim project instance.

  Each question is explained and has an overridable default value specified
  between square brackets.
  Should you have made a mistake, you can execute \`make init\`
  again to fix the faulty setting value you need.
EOF

}

my_sed() {
  local sed_cmd='gsed'

  if ! command -v "${sed_cmd}" >/dev/null; then
    sed_cmd='sed'
  fi

  echo "${sed_cmd}"
}

get_first_empty_line_in_file_from() {
  local file="$1"
  local begin=$2
  local it=$begin

  while ! "$(my_sed)" -n -r "$it p" "${file}" | grep -E '^$' >/dev/null; do
    it=$((it + 1))
  done

  echo "${it}"
}

get_first_section_line_in() {
  local file="$1"

  local it=0 &&
    it=$(get_first_empty_line_in_file_from "${file}" 1) &&
    it=$(get_first_empty_line_in_file_from "${file}" $((it + 1)))

  echo $((it + 1))
}

extract_sections_in() {
  local file="$1"

  local it &&
    it=$(get_first_section_line_in "${file}")

  "$(my_sed)" -n -r "$it,$ p" "${file}"
}

get_top_section_last_line_index() {
  local sections="$1"
  local it=5 # ignore the 4 first line of section header
  local last_line_not_found=0

  while [ $last_line_not_found -eq 0 ]; do
    echo "${sections}" | "$(my_sed)" -n "$it p" | grep -E -v '^##+#$' >/dev/null

    last_line_not_found=$?

    it=$((it + 1))
  done

  echo $((it - 1))
}

top_section() {
  local sections="$1"

  local top_section_last_line_index &&
    top_section_last_line_index=$(get_top_section_last_line_index "${sections}")

  local section_line_count=$((top_section_last_line_index - 1))

  echo "${sections}" | "$(my_sed)" -r -n "1,$section_line_count p"
}

print_section_header() {
  local section="$1"

  set_print_color_light_grey

  echo "${section}" |
    "$(my_sed)" -n '2 p' |
    "$(my_sed)" -E 's/^# //' |
    "$(my_sed)" -E 's/$/ CONFIGURATION/'

  set_print_color_default
}

format_section_declarations() {
  local headerless_section &&
    headerless_section="$(echo "${section}" | "$(my_sed)" -n '5,$ p')"

  echo "${headerless_section}" |
    "$(my_sed)" -E 's/(^[A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*$)/\1=\2/'
}

get_top_question_last_line_index() {
  local questions="$1"
  local it=1
  local last_line_not_found=0

  while [ $last_line_not_found -eq 0 ]; do
    echo "${questions}" | "$(my_sed)" -n "$it p" | grep -E -v '^$' >/dev/null

    last_line_not_found=$?

    it=$((it + 1))
  done

  echo $((it - 1))
}

top_question() {
  local questions="$1"

  local top_question_last_line_index
  top_question_last_line_index=$(get_top_question_last_line_index "${questions}")

  local question_line_count=$((top_question_last_line_index - 1))

  echo "${questions}" | "$(my_sed)" -n "1,$question_line_count p"
}

get_variable_line_index() {
  local body="$1"
  local it=1
  local last_line_not_found=0

  while [ $last_line_not_found -eq 0 ]; do
    echo "${body}" | "$(my_sed)" -n "$it p" | grep -E '^#' >/dev/null

    last_line_not_found=$?

    it=$((it + 1))
  done

  echo $((it - 1))
}

get_question_description() {
  local body="$1"

  local variable_line_index &&
    variable_line_index=$(get_variable_line_index "${body}")

  local description_line_count &&
    description_line_count=$((variable_line_index - 1))

  echo "${body}" |
    "$(my_sed)" -n "1,$description_line_count p" |
    "$(my_sed)" -E 's/^# /  /'
}

get_question_variable_definition() {
  local body="$1"

  local variable_line_index &&
    variable_line_index=$(get_variable_line_index "${body}")

  echo "${body}" |
    "$(my_sed)" -n "$variable_line_index p"
}

get_question_variable_name() {
  local body="$1"

  get_question_variable_definition "${body}" |
    "$(my_sed)" -E 's/(^[^=]+)=.*/\1/'
}

get_question_variable_value() {
  local body="$1"

  get_question_variable_definition "${body}" |
    "$(my_sed)" -E 's/^[^=]+=(.*)/\1/'
}

update_variable_in_file() {
  local file="$1"
  local variable_name="$2"
  local variable_value="$3"

  "$(my_sed)" -E -i \
    "s%^${variable_name}\s*=\s*.*\$%${variable_name}=${variable_value}%" \
    "${file}"
}

ask_question() {
  local body="$1"
  local file="$2"

  local description &&
    description="$(get_question_description "${body}")"

  local variable_name &&
    variable_name="$(get_question_variable_name "${body}")"

  local variable_value &&
    variable_value="$(get_question_variable_value "${body}")"

  set_print_color_light_grey
  echo "  ${variable_name}:"

  set_print_color_default
  echo "${description}"

  set_print_color_light_grey
  read -p \
    "  [${variable_value}]: " \
    "${variable_name?}"

  set_print_color_default
  eval 'local value=$'"${variable_name}"

  if [ -n "$value" ]; then
    update_variable_in_file "${file}" "${variable_name}" "${value}"
  fi
}

pop_question() {
  local questions="$1"
  local it=1

  while ! echo "${questions}" |
    "$(my_sed)" -n -r "$it p" |
    grep -E '^[^=]+=.*$' >/dev/null; do
    it=$((it + 1))
  done

  it=$((it + 2)) # An empty line to pass and onother to reach the next question

  echo "${questions}" |
    "$(my_sed)" -n "$it,$ p"
}

ask_questions_of_section_in_file() {
  local section="$1"
  local file="$2"

  local questions
  questions="$(format_section_declarations "${section}")"

  local last_exit_code=$?

  while [ -n "${questions}" ] && [ ${last_exit_code} -eq 0 ]; do
    local question &&
      question="$(top_question "${questions}")" &&
      ask_question "${question}" "${file}" &&
      questions="$(pop_question "${questions}")"
  done
}

pop_section() {
  local sections="$1"

  local next_section_line_index &&
    next_section_line_index=$(get_top_section_last_line_index "${sections}")

  echo "${sections}" |
    "$(my_sed)" -n "$next_section_line_index,$ p"
}

ask_questions_for_file() {
  local file="$1"

  local sections
  sections="$(extract_sections_in "$file")"

  local last_exit_code=$?

  while [ -n "${sections}" ] && [ ${last_exit_code} -eq 0 ]; do
    local section &&
      section="$(top_section "${sections}")" &&
      print_section_header "${section}" &&
      ask_questions_of_section_in_file "${section}" "${file}" &&
      sections="$(pop_section "${sections}")"
  done
}

report_init_done() {
  cat <<EOF

The initialization of this nideovim project instance is now complete.
You may build, launch and log in to you ide service by issuing: \`make shell\`.
EOF
}

init() {
  print_init_header &&
    ask_questions_for_file "Makefile.env" &&
    report_init_done
}

set_print_color_default_and_exit() {
  set_print_color_default

  exit
}

setup_signal_handling() {
  trap set_print_color_default_and_exit INT
}

main() {
  setup_signal_handling &&
    init
}

main
