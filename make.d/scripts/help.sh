set_print_color_default() {
  printf '\033[0;0m'
}

set_print_color_light_grey() {
  printf '\033[1;37m'
}

main() {
  set_print_color_default
  cat <<EOF

Usage: make \`target\` with \`target\` one of:

EOF

  set_print_color_light_grey
  cat <<EOF
- help: displays this message.
EOF

  set_print_color_default
  cat <<EOF
- build: builds the docker image of this integrated development environment.
EOF

  set_print_color_light_grey
  cat <<EOF
- up: starts the development environment service as a docker compose project.
EOF

  set_print_color_default
  cat <<EOF
- shell: logs in into the integrated development environment. To exit, press
         ctrl-d.
EOF

  set_print_color_light_grey
  cat <<EOF
- down: stops the development environment service. It will turn off all
        containers, keeping state into the docker compose project volumes.
EOF
}

main
