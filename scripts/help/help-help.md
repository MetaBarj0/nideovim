# Introduction

Welcome in `nideovim`, the development environment fabricator.

Here is the detailed help system.

There is a lot of information here thus, if you want more a summarized help,
type `make help` instead.

You may have noticed this help message has a `markdown` format. Therefore, you
can output the `make help-help` output to a file and read it with your favorite
`markdown` reader.

Alternatively, you can directly read the `scripts/help/help-help.md` file
directly in your `markdown` reader.

## What is `nideovim`?

Basically, it's a tool for developers who want power without sacrificing
efficiency.

### Power?

For developers, power is tooling.
`nideovim` leverages wonderful open-source projects such as Linux, docker and
eovim💤 (to name a few).

Neovim is at the core of the tooling with its many community-driven plugins
supported plethora of development activities.

Besides, you can also integrate powerful A.I tooling such as Claude to
accelerate even more.

### Efficiency?

Terminal based, no need for any GUI or fancy `hardware GPU driven
acceleration`. The power of this tooling is not associated with any visually
fancy features.

However, with a proper font-set such as
[nerd-fonts](https://www.nerdfonts.com/font-downloads) you can have a visually
clear and appealing UI for any development purpose.

Please, note nonetheless the learning curve might be steep. Not for the faint
of heart some people could say 😆

## How is `nideovim` done?

Basically, it's a `GNU ake` project.

Yup, you read right, a good old `Makefile` is responsible to fabricate your
favorite environment.

You can see this like a wrapper around more modern tools (such as `docker
compose `).

There is some vocabulary you have to get acquainted with before continuing as
you'll see those words a lot.

### An environment has a `type` and implemented in an `instance`

An `instance` is a ready-to use environment for your projects.
You can create as many `instance` you like with `nideovim`.
`nideovim` can manage any number of `instance`.

Each `instance` has a `type`.
In `nideovim`, there is at least one `type` called `base`.
The `base` `type` is the most basic though very capable as it is capable to
handle a lot of projects (especially native ones working with C/C++ and Node.js
projects).

You can create as many `type` as you like to handle any project fuelled by your
imagination. Sky's the limit, checkout out the section about creating a `type`
==TODO==.

- It could be a `type` for modern c/c++ projects
- It could be a `type` for next.js/React projects
- It could be a `type` for Ethereum Virtual Machine compatible decentralized
  application projects.
- It could be a `type` for your complete bundle of World of Warcraft server
  project.
- It could be a `type` for any project you imagine.

## How can I use `nideovim`

Good thing first, it is designed to be easy to use and extend.

### For project developers

Ideally, a developer working on its project work a bit on its tooling before
delving into the project.
One of `nideovim` goals is to shorten as much as possible this setup time to
boost the developer productivity, especially if the team uses `nideovim`.

#### A typical use case

1. Clone the `nideovim` repository
2. `make help` is your best friend to get started
3. You figure out you can invoke `make new-help` to get detailed help about
   `instance` creation
4. You figure out you can invoke `make new` to create an instance and you
   follow the guide.
5. If you are not satisfied by the way you initialized your `instance` you can
   invoke `make init` and change any variable related to the `instance` of your
   choice
6. You can access the help system of your new instance by typing `make
   instance-help`. It may contain valuable information on how this `instance`
   work and what kind of project it can support.
7. You can then start the `instance` with the `make up` command.
8. Once it's started, you can login into the environment with `make login`
9. Unleash you raw creativity power into this new `instance` using all the
   tools at your disposal.
   HINT: type `make new build up login` to create and use your `instance` with
         a single command!
10. Need a break? Just logout from your `instance` with `ctrl-d`. You can
    re-enter in it later on with `make login`.
11. Your nasty project's done? Angry after `nideovim`, want to erase your
    `instance` from the surface of the Earth? Whatever your reasons, you can
    remove all traces of your `instance` with the `make nuke` command.
    If you find it's a bit extreme, take a look at your `instance` specific
    help message with the `make instance-help` command and learn how to `stop`,
    `rebuild` or even `upgrade` it.
12. Once your `instance` artifact are deleted (understand you `nuke`d it like a
    psychopath), you can `delete` the instance from `nideovim`. You can
    re-create it later with `make new` fortunately!

### For `types` maintainers and `type` creators

#### Manual process

1. Clone the `nideovim` repository
2. `make help` is your best friend to get started
3. `make list-types` shows you existing types. Maybe existing one is good for
   your purposes?
4. Following steps assume you want to create a new type
    1. Find a good name for your `type`
    2. create a directory into the `types` directory having the name of your
       `type`
    3. Within this directory:
        1. replicate the following directory structure:
            - docker
            - make
            - scripts
        2. create core files of the `type`:
            - metadata (contains `type` description and `ancestor type`)
            - Makefile (contains specific logic and use `ancestor` logic)
        3. create scripts needed to run your `type`'s logic.
            - in the `scripts` directory of your `type`
            - a `build.sh` script to build the docker image of your `type`
            - a `default.sh` scripts containing overrides from the `ancestor`
              as well as variables and their default values that are related to
              your new `type`
            - a `init.sh` defining mandatory function used in the `instance`
              initialization process to build the `Makefile.env` file.
            - a `Makefile.env.sh` script that is responsible to generate the
              `type` `Makefile.env` file at `instance` initialization. In
              general, you just have to rely on the `ancestor` logic for
              `Makefile.env` file creation.
        4. create docker file needed to build and run `instances` of your newly
           created `type`
            - in the `docker` directory of your `type`
            - create the `ide/ide.Dockerfile` should you have any stuff to add
              to the `ancestor`'s `type` image. This is for the build process
              of your `instance`
            - create both:
                - a `compose.yaml` file.
                - a `override.yaml` file.
5. Take a look at the `next_react type` to get more insights.

#### semi-automated process

This way is easier in the step of creation of file and directory structure for
your new type. Keep in mind However you'll have to edit files according what
you want to achieve for your `type`.

1. Run the `make new-type` command and answer questions ==TODO==
2. Once you've answered all questions, edit generated files in your `type`
   folder accordingly. (Refer to Manual process section)
