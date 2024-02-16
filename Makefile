main: toc readme
.PHONY: main

~ := toc
[ := head.md with.md func-on-one-line.md misc.md bash-from-md.md
] := tmp/$~.md
$]: $] := { pandoc -f gfm -t gfm --$~ --template $~.md --columns=196; echo; }
$]: $[ | $(dir $]); cat $^ | $($@) > $@
$~: $]
.PHONY: $~

tmp/:; mkdir -p $@

~ := readme
[ := $] $[
] != echo -n $~ | tr '[:lower:]' '[:upper:]'; echo .md
$]: $[; grep -hv '\[.*:.*\]::' $^ > $@
$~: $]
.PHONY: $~
