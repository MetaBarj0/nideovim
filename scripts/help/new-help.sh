cat <<EOF
The \`make new\` command is responsible to create a new instance and eventually
set this instance as default instance.

The process is fully interactive and divided in 3 steps:

1. selecting the \`type\` of the instance. Here you specify a string
   corresponding to supported \`instance\` \`types\`. If you interrupt the
   \`instance\` creation here with \`ctrl-c\`, nothing is created.
2. initializing the \`instance\` using the \`instance\` initialization
   facility. If you interrupt the process of \`instance\` initialization, it is
   still created. Therefore, you can initialize it later.
3. set the created \`instance\` as the default \`instance\` if you wish.
   Note that if the created \`instance\` is the very first, it is automatically
   set as the default \`instance\`. If you interrupt the process here, default
   \`instance\` is not changed.
EOF
