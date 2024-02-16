README.md: head.md with.md func-on-one-line.md misc.md; cat $^ | grep -v '\[.*:.*\]::' > $@
