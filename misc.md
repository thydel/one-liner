# Misc funcs

- See [misc.sh][]

```bash
files=(with func-on-one-line misc bash-from-md short)
sources () { for file in ${files[@]}; do source $file.sh; done; }
items () { for file in ${files[@]}; do $file.list; done; }
```

```console
$ sources; items | loop args | sort -u | loop item
args () { for arg in "$@"; do echo $arg; done; };
declare -A awk=([bash-from-md]="/^\`\`\`bash/ { ++b; next } b && /^: name=/ { FS = \"=\"; \$0 = \$0; s = \$2 } /^\`\`\`\$/ { --b; s = \"\" } b && s { t[s] = t[s] \$0 RS } END { print t[n] }" )
awkf () { awk "$@" "${awk[${FUNCNAME[1]}]}"; };
bash-from-md () { awkf -v n=${1:?}; };
func-on-one-line () { local -n a=MAPFILE; mapfile -t < <(declare -f ${1:?}); ((${#a[*]})) || return 1; local i t; for ((i = 2; i < $((${#a[*]} - 1)); ++i)) do t=${a[(($i + 1))]}; printf -v n -- ${t/\%/%%}; [[ ${#n} == 1 && ${n:(-1)} == "}" ]] || [[ ${#n} == 2 && ${n:(-2)} == "};" ]] && a[$i]+=";"; done; a[-1]+=';'; a=("${a[@]% }"); echo "${a[@]##*( )}"; };
item () { declare -p $1 &> /dev/null && declare -p $1; func-on-one-line $1; };
loop () { while read; do eval "$@" $REPLY; done; };
short () { : ${1:?}; until [[ $# == 1 || $1 == -- ]]; do item $1; shift; done; if [[ $1 == -- ]]; then shift; fi; item $1; echo $@; };
with () { : ${1:?}; until [[ $# == 1 || $1 == -- ]]; do with.decl $1; shift; done; if [[ $1 == -- ]]; then shift; fi; with.decl $1; echo $@; };
with.decl () { declare -p $1 &> /dev/null && declare -p $1; declare -f $1; };
```

[misc.sh]: misc.sh "sibling file"

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
