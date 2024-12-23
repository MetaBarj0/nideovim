. make.d/lib.d/color.sh

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
- init: starts the interactive initialization feature for this project. You
        will have several question to answer. Once you've finished, you will be
        able to run any make target described below.
EOF

  set_print_color_light_grey
  cat <<EOF
- build: builds the docker image of this integrated development environment.
EOF

  set_print_color_default
  cat <<EOF
- up: starts the development environment service as a docker compose project.
EOF

  set_print_color_light_grey
  cat <<EOF
- shell: logs in into the integrated development environment. To exit, press
         ctrl-d.
EOF

  set_print_color_default
  cat <<EOF
- down: stops the development environment service. It will turn off all
        containers, keeping state into the docker compose project volumes.
EOF

  set_print_color_light_grey
  cat <<EOF
- clean: cleans the system of the ide docker image. It implies down. It removes
         the image but does not clear the build cache.
EOF

  set_print_color_default
  cat <<EOF
- config: check the docker compose file correctness. If everything is good,
          returns 0 and print the content of the compose.yaml file on stdout.
EOF

  set_print_color_light_grey
  cat <<EOF
- ps: get the running status of services for this compose project
EOF
}

main
