# deovim

This is an Integrated Development Environment (`IDE`) based on Linux Debian and
the latest version of `neovim`

## prerequisites

### usage

- terminal based
- no graphical user interface

### tooling

- POSIX compliant shell
- rev
- cut
- docker
  - buildx plugin
  - compose plugin
- make
- command
- GNU sed
- (optional) less

### hardware

- some giga-bytes of free storage to build and use the stuff

## how to use?

1. build the `IDE` with the `make build` command.
2. start the `IDE` with the `make up` command.
3. use the `IDE` with the `make shell` command.
4. shutdown with the `make down` command.
5. getting some help with the `make help` command.

# TODO

- pseudo-rootless mode
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
