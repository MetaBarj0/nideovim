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
7. ==TODO==

### For `type` maintainers

1. Clone the `nideovim` repository
2. `make help` is your best friend to get started
3. `make list-types` shows you existing types. Maybe existing one is good for
   your purposes?
4. ==TODO==
