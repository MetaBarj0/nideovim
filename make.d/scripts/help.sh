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
         This target behavior can be customized using variables. See below
         about which variables and values they can have to custome your ide
         image build.
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

  set_print_color_default
  cat <<EOF

Specific target variables:

EOF

  set_print_color_light_grey
  cat <<EOF
- build: below are the \`build\` specific variables you can use to custom the
         ide service docker image build.
EOF

  set_print_color_default
  cat <<EOF
  - target_stage: This variable specifies the final target to use in order to
    build the ide service docker image. It can be useful to debug or test the
    image build process without having to complete the build until the very
    last build stage. See in the file
    \`docker.d/ide/ide.unoptimized.Dockerfile\` for all build stages.
    Note that specifying an build stage other than \`end\` in this variable
    prevents the built image to be optimized.
    Default value: end
EOF

  set_print_color_light_grey
  cat <<EOF
  - build_type: This variable specifies the build type of the ide service
                docker image.
                Default value: unoptimized
                This variable can have two distincts values:
    - unoptimized: the \`build\` target will produce an unoptimized image. Such
                   an image is not flattened and can contains some
                   inefficiencies such as duplicated data wetween layers.
                   The advantage is faster build time and reusable build cache
                   content.
    - optimized: the \`build\` target will produce an optimized image. Such an
                 image is flattend thus do not contain any duplicated data.
                 The advantage of such an image is its readiness to be
                 published but it is longer to build.
EOF
}

main
