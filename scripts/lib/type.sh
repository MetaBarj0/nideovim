get_longest_type_name() {
  find instances/* -maxdepth 1 -mindepth 1 -type d -exec basename {} \; |
    awk '{print length}' |
    sort -nr |
    head -n1
}
