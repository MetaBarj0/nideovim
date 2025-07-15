cat <<EOF
Welcome in \`nideovim\`, the development environment fabricator.

Available targets:

- \`help\`: display this message.
- \`new\`: create a new environment
- \`set-default\`: set a default instance among existing instances
- \`instance-help\`: get a help message of a created instance
- \`list\`: print a list of existing instances
- \`list-types\`: print a list of existing instance type you can create
- \`delete\`: delete an existing \`instance\`.
- \`migrate\`: migrate an outdated \`instance\` regarding a \`type\`.

You can get detailed help for a specific target by specifying \`-help\` after
the target name (e.g. \`make new-help\`)
EOF
