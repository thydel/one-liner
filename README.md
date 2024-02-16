-   [What ?](#what-)
-   [Project selected vars and func as bash workspace](#project-selected-vars-and-func-as-bash-workspace)
    -   [Workspace](#workspace)
    -   [Play it on remote node](#play-it-on-remote-node)
    -   [Add a local minimal plot](#add-a-local-minimal-plot)
-   [Output func on one line](#output-func-on-one-line)
-   [Allow easy copy-paste and on the fly edition](#allow-easy-copy-paste-and-on-the-fly-edition)
-   [Misc funcs](#misc-funcs)
-   [Extract bash stanzas from mardown files](#extract-bash-stanzas-from-mardown-files)
    -   [Clean current workspace](#clean-current-workspace)
    -   [Source the tool](#source-the-tool)
    -   [Use it to source stanza `syslog-by-hours` from `with.md`](#use-it-to-source-stanza-syslog-by-hours-from-withmd)
    -   [Use the sourced stanza](#use-the-sourced-stanza)

# What ?

Some one-liner or minimalist `bash`, `jq` and `awk`stuff

# Project selected vars and func as bash workspace

- See [with.sh][]

[with.sh]: with.sh "sibling file"

## Workspace

- We want to count the number of `syslog` lines by hour for all syslog
  files on any remote node (using `ssh localhost` to demo)

```bash
: name=syslog-by-hours

declare -A jq=()
# Get epochs from syslog lines
jq[epochs]='./"." | first | strptime("%Y-%m-%dT%H:%M:%S") | mktime'
# Count syslog lines by hours
jq[by-hours]='map(gmtime) | group_by(.[3]) | map(length)[]'

# Use jq code associated with a func
jqf () { jq -M "${jq[${FUNCNAME[1]}]}" "$@"; }

# All compressed and uncompressed syslog files concatenated
syslogs () { zgrep . /var/log/syslog* | cut -d: -f2-; }

# Use our jq code
epochs () { syslogs | jqf -R | sort -n; }
by-hours () { epochs | jqf -s; }
```

## Play it on remote node

- use `with`

```bash
: name=syslog-by-hours

source with.sh
lib=(jq jqf syslogs epochs by-hours)
```

- Call a specific func (e.g. for testing)

```bash
with ${lib[@]} -- syslogs | ssh localhost -l root bash | head
```

- Default to call the last arg of `with`

```console
$ with ${lib[@]} | ssh localhost -l root bash | fmt
1463 689 415 421 420 681 494 770 1267 7902 1920 849 2064 2091 5199 1401
758 1282 4990 4468 1692 1037 1013 1093
```

## Add a local minimal plot

- See [zoom.jq][]

```bash
with ${lib[@]} | ssh localhost -l root bash | jq -sr 'include "zoom"; plot(sqrt; 80; 20)'
```

---

```
                              ███                                               
                              ███                                               
                              ███                                               
                              ███                                               
                              ███              ███          ███                 
                              ███              ███          ██████              
                              ████             ███          ██████              
                              ████            ████          ███████             
                              ████            ████          ███████             
                              ████            ████          ███████             
                              ██████    ██████████          ███████             
███                           ███████   ██████████          ██████████          
███                        ██████████   █████████████    █████████████          
████                      ████████████████████████████  ████████████████████████
███████          ███   █████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████
```

[zoom.jq]: zoom.jq "sibling file"

# Output func on one line

- See [func-on-one-line.sh][]
- Aliased as `func`
- Argument of alias is expanded (so that `func func` is exanped as
  `func-on-one-line func-on-one-line`)

```console
$ source func-on-one-line.sh
$ func func
func-on-one-line () { local -n a=MAPFILE; mapfile -t < <(declare -f ${1:?}); ((${#a[*]})) || return 1; local i t; for ((i = 2; i < $((${#a[*]} - 1)); ++i)) do t=${a[(($i + 1))]}; printf -v n -- ${t/\%/%%}; [[ ${#n} == 1 && ${n:(-1)} == "}" ]] || [[ ${#n} == 2 && ${n:(-2)} == "};" ]] && a[$i]+=";"; done; a[-1]+=';'; echo ${a[@]}; };
```
[func-on-one-line.sh]: func-on-one-line.sh "sibling file"

# Allow easy copy-paste and on the fly edition

```console
source <(func func | sed s/^func-on-one-line/fool/)
```

# Misc funcs

- See [misc.sh][]

```bash
files=(with func-on-one-line misc bash-from-md)
sources () { for file in ${files[@]}; do source $file.sh; done; }
items () { for file in ${files[@]}; do $file.list; done; }
```

```console
$ sources; funcs | loop args | loop item
with () { until [[ $# == 1 || $1 == -- ]]; do with.decl $1; shift; done; if [[ $1 == -- ]]; then shift; fi; with.decl $1; echo $@; };
with.decl () { declare -p $1 &> /dev/null && declare -p $1; declare -f $1; };
func-on-one-line () { local -n a=MAPFILE; mapfile -t < <(declare -f ${1:?}); ((${#a[*]})) || return 1; local i t; for ((i = 2; i < $((${#a[*]} - 1)); ++i)) do t=${a[(($i + 1))]}; printf -v n -- ${t/\%/%%}; [[ ${#n} == 1 && ${n:(-1)} == "}" ]] || [[ ${#n} == 2 && ${n:(-2)} == "};" ]] && a[$i]+=";"; done; a[-1]+=';'; echo ${a[@]}; };
item () { declare -p $1 &> /dev/null && declare -p $1; func-on-one-line $1; };
args () { for arg in "$@"; do echo $arg; done; };
loop () { while read; do eval "$@" $REPLY; done; };
declare -A awk=([bash-from-md]="/^\`\`\`bash/ { ++b; next } b && /^: name=/ { FS = \"=\"; \$0 = \$0; s = \$2 } /^\`\`\`\$/ { --b; s = \"\" } b && s { t[s] = t[s] \$0 RS } END { print t[n] }" )
awkf () { awk "$@" "${awk[${FUNCNAME[1]}]}"; };
bash-from-md () { awkf -v n=${1:?}; };
```

[misc.sh]: misc.sh "sibling file"

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

