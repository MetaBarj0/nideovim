# deovim

This is an Integrated Development Environment (`IDE`) based on Linux Debian and
the latest version of `neovim`

## prerequisites

### usage

- terminal based
- no graphical user interface

### tooling

- docker
  - buildx plugin
  - compose plugin
- make

### hardware

- some giga-bytes of free storage to build and use the stuff

## how to use?

1. build the `IDE` with the `make build` command.
2. start the `IDE` with the `make up` command.
3. use the `IDE` with the `make shell` command.
4. shutdown with the `make down` command.
5. getting some help with the `make help` command.

# TODO

- think about a way to link this project with the `environment` repository
- make based project
- docker compose
- define environment config
- builtin support for `dive` in the build process
  - in progress
