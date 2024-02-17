# Concise version of `with`

- See [short.sh][]
- Concise by output not by src
- Use `func-on-one-line` instead of `declare -f` in a modified `with`
- Show a workspace as a sequence of item (var or func) each on a line

## Show expasion of short

```console
$ source short.sh; source misc.sh
$ short.list | loop args | loop item
func-on-one-line () { local -n a=MAPFILE; mapfile -t < <(declare -f ${1:?}); ((${#a[*]})) || return 1; local i t; for ((i = 2; i < $((${#a[*]} - 1)); ++i)) do t=${a[(($i + 1))]}; printf -v n -- ${t/\%/%%}; [[ ${#n} == 1 && ${n:(-1)} == "}" ]] || [[ ${#n} == 2 && ${n:(-2)} == "};" ]] && a[$i]+=";"; done; a[-1]+=';'; a=("${a[@]% }"); echo "${a[@]##*( )}"; };
item () { declare -p $1 &> /dev/null && declare -p $1; func-on-one-line $1; };
short () { : ${1:?}; until [[ $# == 1 || $1 == -- ]]; do item $1; shift; done; if [[ $1 == -- ]]; then shift; fi; item $1; echo $@; };
```

## Get a workspace

```bash
exec bash
source bash-from-md.sh
source <(< with.md bash-from-md syslog-by-hours)
source short.sh
```

## Show concise version of workspace

```console
$ short ${lib[@]}
declare -A jq=([epochs]="./\".\" | first | strptime(\"%Y-%m-%dT%H:%M:%S\") | mktime" [by-hours]="map(gmtime) | group_by(.[3]) | map(length)[]" )
jqf () { jq -M "${jq[${FUNCNAME[1]}]}" "$@"; };
syslogs () { zgrep . /var/log/syslog* | cut -d: -f2-; };
epochs () { syslogs | jqf -R | sort -n; };
by-hours () { epochs | jqf -s; };
by-hours
```

[short.sh]: short.sh "sibling file"
