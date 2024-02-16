[ := head.md with.md func-on-one-line.md misc.md bash-from-md.md
] := README.md
$]: $[; grep -v '\[.*:.*\]::' $^ > $@
