cat <<EOF
The \`migrate help\` command migrate an existing and outdated \`instance\`.
Once the command is successfully executed, the targeted outdated \`instance\`
becomes up-to-date regarding its type.

Use this command when the underlying \`type\` of your \`instance\` (or one or
more of its \`ancestor type\`s) have been updated after you've created your
\`instance\`.

If the underlying \`type\` of your instance did not change, this command has no
effect. The same if none of the \`ancestor type\` of your \`instance\` have
been updated.

It is easy to notice an outdated \`instance\`. Actually, each time an
\`instance\` is presented, you can see if it is \`up to date\` or \`outdated\`.
You can figure out easily with \`make list\` for instance.
EOF
