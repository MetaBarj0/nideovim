cat <<EOF
The \`make delete\` command is responsible to delete an existing \`instance\`.

The process is fully interactive and divided in 4 steps:

1. You have to select the \`instance\` to delete among existing \`instances\`.
2. The \`instance\` must not have any built or running artifacts. it means that
   it remains any docker image, docker container or docker volume associated to
   the \`instance\` you try to delete, it will fail.
   HINT: if your \`instance\` is a descendant of the \`base type\`, you can
         \`nuke\` the instance to remove all aforementionned artifacts.
3. If there are not any artifacts associated to the \`instance\` you want to
   delete, the \`instance\` is actually deleted.
4. You are asked to select a new default \`instance\` if the \`instance\` you
   deleted was the default one. You may interrupt this process if you wish. It
   would result \`nideovim\` having no default \`instance\`. You can choose a
   default \`instance\` later with the \`set-default\` make target.
EOF
