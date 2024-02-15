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

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
