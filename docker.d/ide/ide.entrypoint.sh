#!/bin/env sh

clone_repository() {
  cd /tmp || return $?

  rm -rf environments

  git clone --branch=master --depth=1 \
    https://github.com/MetaBarj0/environments.git
}

install_files() {
  cd /tmp/environments || return $?

  rm -rf ${USER_HOME_DIR}/.bashd
  rm -rf ${USER_HOME_DIR}/.bashrc
  cp -r common/bash/USER_HOME_DIR/.bash* ${USER_HOME_DIR}/

  rm -rf ${USER_HOME_DIR}/.gitconfig
  cp -r common/git/USER_HOME_DIR/.gitconfig ${USER_HOME_DIR}/

  rm -rf ${USER_HOME_DIR}/.config/nvim
  rm -rf ${USER_HOME_DIR}/.config/tmux
  cp -r common/neovim/USER_HOME_DIR/.config ${USER_HOME_DIR}/
  cp -r common/tmux/USER_HOME_DIR/.config/tmux/ ${USER_HOME_DIR}/.config/

  rm -rf ${USER_HOME_DIR}/.npmrc
  cp -r common/nodejs/USER_HOME_DIR/.npmrc ${USER_HOME_DIR}/
}

initialize_environment() {
  clone_repository &&
    install_files &&
    touch ${USER_HOME_DIR}/.environments_installed
}

prepare_volumes() {
  cd "${USER_HOME_DIR}" || return $?

  rm -f .config/.volume
  rm -f .local/.volume
  rm -f tmp/.volume
  rm -f "${VOLUME_DIR_NAME}/.volume"
}

run_live_loop() {
  while true; do
    sleep 1
  done
}

main() {
  initialize_environment &&
    prepare_volumes &&
    run_live_loop
}

main
