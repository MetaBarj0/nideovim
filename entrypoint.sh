#/bin/env sh

apply_git_config() {
  ln -s /root/environments/common/git/USER_HOME_DIR/.gitconfig /root/.gitconfig
}

config_git_user() {
  git config --global user.email troctsch.cpp@gmail.com
  git config --global user.name MetaBarj0
}

authorize_github() {
  ssh-keyscan github.com > /root/.ssh/known_hosts
}

apply_neovim_config() {
  ln -s /root/environments/common/neovim/USER_HOME_DIR/.config /root/.config
}

main() {
  apply_git_config \
  && config_git_user \
  && authorize_github \
  && apply_neovim_config \
  && exec bash
}

main
