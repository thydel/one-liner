# Extract bash stanzas from mardown files

- To be used as `source <(< file.md bash-from-md)`
- But we need a way to name stanzas
- Maybe something like

```bash
: name=example
example=42
```

- Then we could use `source <(< bash-from-md.md bash-from-md example)`

## Funcs

```bash
declare -A awk=()
awk[bash-from-md]='BEGIN { i = 0 } /^```bash/ { ++b; next } /^```$/ { --b; ++i } '
awk[bash-from-md]+='b { t[i] = t[i] $0 RS } END { print t[n] }'

awkf () { awk "$@" "${awk[${FUNCNAME[1]}]}"; }

bash-from-md () { awkf -v n=${1:-0}; }
```

## Play

```console
$ < with.md bash-from-md
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

$ < with.md bash-from-md 1
source with.sh
lib=(jq jqf syslogs epochs by-hours)
```

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
