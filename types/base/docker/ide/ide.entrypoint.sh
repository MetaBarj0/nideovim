#!/bin/env sh

setup_ssh_authentication() {
  cd "${USER_HOME_DIR}" || return $?

  mkdir -p .ssh
  chmod 0755 .ssh

  cat /run/secrets/ssh_public_key_file >.ssh/id.pub
  chmod 0444 .ssh/id.pub

  cat /run/secrets/ssh_secret_key_file >.ssh/id
  chmod 0400 .ssh/id
}

run_live_loop() {
  while true; do
    sleep 1
  done
}

main() {
  setup_ssh_authentication &&
    run_live_loop
}

main
