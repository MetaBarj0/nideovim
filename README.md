# nideovim

This is an Integrated Development Environment (`IDE`) based on Linux Debian and
the latest version of `neovim` (tip of the `master` branch)

## prerequisites

### usage

- terminal based
- no graphical user interface

### tooling

- POSIX compliant shell
- rev
- cut
- docker (either native or Docker Desktop or Orbstack)
  - buildx plugin
  - compose plugin
- make
- command
- GNU sed
- (optional) less

Generally speaking, a recent linux distribution or MacOS should do the job.
For MacOS, ensure to install `gsed` using Homebrew for instance.

### hardware

- some giga-bytes of free storage to build and use the stuff

## how to use?

1. configure the project interactively with the `make init` command.
2. build the `IDE` with the `make build` command.
3. start the `IDE` with the `make up` command.
4. use the `IDE` with the `make shell` command.
5. shutdown with the `make down` command.
6. getting some help with the `make help` command.

## nideovim-based projects

[nideovim_react](https://github.com/MetaBarj0/nideovim_react.git) gather all
`nideovim` offers and extends it to facilitate react/next application
development
