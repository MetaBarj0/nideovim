cat <<EOF
The \`make set-default\` command set an existing instance as the default
instance.

The default \`instance\` is the instance that is systematically proposed first
for any operation.

Note that at \`instance\` creation, you are proposed to set the newly created
\`instance\` as default (unless this is the very first created \`instance\`).

Note also that an \`instance\` is identified by both:

1. A name, decided at \`instance\` initialization (after its creation) that can
  change over time (at \`instance\` initialization).
2. An identifier, a number that is decided at \`instance\` creation and that is
   fixed all along the \`instance\` lifetime.

The process is fully interactive:

1. Type \`make set-default\`
2. A list of existing \`instances\` is presented with the current default one
   at first. You can see the default \`instance\` clearly as it is prepended by
   \`->\`
3. Should you be satisified with the current default \`instance\`, just hit
   \`<enter>\` to finish the process.
4. Otherwise, type the identifier of one of the \`instances\` to change the
   default \`instance\`.
5. An abort is also possible by hitting \`ctrl-c\`. In that case, nothing is
   changed.
EOF
