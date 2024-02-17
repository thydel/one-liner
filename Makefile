main: toc readme
.PHONY: main

mds := head with func-on-one-line misc bash-from-md short

~ := toc
[ := $(mds:%=%.md)
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
