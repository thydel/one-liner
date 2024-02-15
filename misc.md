# Misc funcs

- See [misc.sh][]

```bash
files=(with func-on-one-line misc)
sources () { for file in ${files[@]}; do source $file.sh; done; }
funcs () { for file in ${files[@]}; do $file.list; done; }
```

```console
$ sources; funcs | loop args | loop func
with () { until [[ $# == 1 || $1 == -- ]]; do with.decl $1; shift; done; if [[ $1 == -- ]]; then shift; fi; with.decl $1; echo $@; };
func-on-one-line () { local -n a=MAPFILE; mapfile -t < <(declare -f ${1:?}); ((${#a[*]})) || return 1; local i t; for ((i = 2; i < $((${#a[*]} - 1)); ++i)) do t=${a[(($i + 1))]}; printf -v n -- ${t/\%/%%}; [[ ${#n} == 1 && ${n:(-1)} == "}" ]] || [[ ${#n} == 2 && ${n:(-2)} == "};" ]] && a[$i]+=";"; done; a[-1]+=';'; echo ${a[@]}; };
args () { for arg in "$@"; do echo $arg; done; };
loop () { while read; do eval "$@" $REPLY; done; };
```

[misc.sh]: misc.sh "sibling file"

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
