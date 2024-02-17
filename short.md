# Concise version of `with`

- See [short.sh][]
- Concise by output not by src
- Use `func-on-one-line` instead of `declare -f` in a modified `with`
- Show a workspace as a sequence of item (var of func) each on a line

```bash
exec bash
source bash-from-md.sh
source <(< with.md bash-from-md syslog-by-hours)
source short.sh
```

---

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
