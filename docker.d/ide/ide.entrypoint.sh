#!/bin/env sh

clone_repository() {
  cd /tmp || return $?

  rm -rf environments

  git clone --branch=master --depth=1 \
    https://github.com/MetaBarj0/environments.git
}

install_files() {
  cd /tmp/environments || return $?

  rm -rf /root/.bash*
  cp -r common/bash/USER_HOME_DIR/.bash* /root/

  rm -rf /root/.gitconfig
  cp -r common/git/USER_HOME_DIR/.gitconfig /root/

  rm -rf /root/.config
  cp -r common/neovim/USER_HOME_DIR/.config /root/
  cp -r common/tmux/USER_HOME_DIR/.config/tmux/ /root/.config/

  rm -rf /root/.npmrc
  cp -r common/nodejs/USER_HOME_DIR/.npmrc /root/
}

initialize_environment() {
  clone_repository &&
    install_files &&
    touch /root/.environments_installed
}

run_live_loop() {
  while true; do
    sleep 1
  done
}

main() {
  initialize_environment &&
    run_live_loop
}

main
