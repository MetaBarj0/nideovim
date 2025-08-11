# Do you need help in the forge?

> It's fine but it's a little dull.
> How about to sharpen it up?

## `nideovim` inception

- support instance generation and id attribution in a cross environment context
  - If there is some instance in the host machine
  - And you enter in this instance
   And you create a first new instance within this instance
    - The attributed ID for this instance will be 0
    - Though it should be computed the same way this new instance would be
      created in the original environment.

## `nideovim` efficiency

- optimize instance build in case of large number of instance creation with
  different configuration
  - There is an issue when user query a large number of instance
  - especially when using pseudo rootless mode
  - when specifying different user name and / or user home directory
    - A lot of build stage are replayed
    - it could be avoided
    - and accelerate a lot instance creations
