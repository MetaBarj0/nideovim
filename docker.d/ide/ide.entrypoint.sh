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

setup_ssh_authentication() {
  cd "${USER_HOME_DIR}" || return $?

  mkdir -p .ssh
  chmod 0755 .ssh

  cat /run/secrets/ssh_public_key_file > .ssh/id_rsa.pub
  chmod 0444 .ssh/id_rsa.pub

  cat /run/secrets/ssh_secret_key_file > .ssh/id_rsa
  chmod 0400 .ssh/id_rsa
}

run_live_loop() {
  while true; do
    sleep 1
  done
}

main() {
  initialize_environment &&
    setup_ssh_authentication &&
    run_live_loop
}

main
