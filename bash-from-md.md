# Extract bash stanzas from mardown files

- See [bash-from-md.sh][] and [bash-from-md.awk][]

## Clean current workspace

```bash
exec bash
```

## Source the tool

```
source bash-from-md.sh
```

## Use it to source stanza `syslog-by-hours` from `with.md`

- See [with.md][]

```bash
source <(< with.md bash-from-md syslog-by-hours)
```

[with.md]: with.md "sibling file"

## Use the sourced stanza

```console
$ with ${lib[@]} | ssh localhost -l root bash | fmt
1463 689 415 421 420 681 494 770 1267 7902 1920 849 2174 2189 5233 1428
813 1321 5039 4499 1810 1037 1013 1093
```

[bash-from-md.sh]: bash-from-md.sh "sibling file"
[bash-from-md.awk]: bash-from-md.awk "sibling file"

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
