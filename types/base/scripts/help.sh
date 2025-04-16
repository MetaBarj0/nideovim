cat <<EOF
This is the \`base instance\` of \`nideovim\`.

Here are the available targets for this \`instance type\`:

- \`init\`: start an interactive initialization process for this instance.
- \`build\`: build the \`instance\` relying on variables set by the \`init\`
           target
- \`clean\`: the reciprocal of the \`build\` target. Remove all built
           artifacts: docker containers and docker images. Keep in mind it
           executes the target \`down\` as a prerequisite.
- \`upgrade\`: upgrade the \`instance\` docker image. New packages and new
             versions for built tools!
- \`up\`: Spin up a built \`instance\`. You may have to execute the \`build\`
        target beforehand.
- \`down\`: Shut down a potentially running \`instance\` started with the
  \`up\` target. It also removes the underlying docker container but does not
       remove persistent volumes attached to the \`instance\`.
- \`inspect\`: Inspect a given \`instance\` configuration. If something is
             wrong in the way the \`instance\` is configured, an error message
             will output. Otherwise, a \`yaml\` formatted configuration will be
             output.
- \`nuke\`: As dangerous as the name suggests. In essence, this is the same
          thing as \`clean\`. However, persistent volume attached to this
          \`instance\` will also be deleted. You'll lost everything of this
          \`instance\`. You've been warned, uniquely viable for mushrooms
          hardcore fans.
EOF
