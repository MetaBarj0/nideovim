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

# TODO

- a way to get this project extensible:
  - sensible and simple way to specify a custom base image (today, only
    debian:stable-slim is supported)
    - By specifying an external `Dockerfile` as well as a script to build it
      and a set of arguments to call the specified  build script?
  - sensible and simple way to extend the ide service docker image with
    supplemental tooling for other purposes.
    - By specifying an external `Dockerfile` as well as a script to build it
      and a set of arguments to call the specified  build script?
  - Prepare a directory structure
    - for the custom base image
    - for the custom resulting image
