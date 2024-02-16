# Project selected vars and func as bash workspace

- See [with.sh][]

[with.sh]: with.sh "sibling file"

## Workspace

- We want to count the number of `syslog` lines by hour for all syslog
  files on any remote node (using `ssh localhost` to demo)

```bash
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

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
