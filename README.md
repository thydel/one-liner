head.md:# What ?
head.md:
head.md:Some one-liner or minimalist `bash`, `jq` and `awk`stuff
head.md:
with.md:# Project selected vars and func as bash workspace
with.md:
with.md:- See [with.sh][]
with.md:
with.md:[with.sh]: with.sh "sibling file"
with.md:
with.md:## Workspace
with.md:
with.md:- We want to count the number of `syslog` lines by hour for all syslog
with.md:  files on any remote node (using `ssh localhost` to demo)
with.md:
with.md:```bash
with.md:declare -A jq=()
with.md:# Get epochs from syslog lines
with.md:jq[epochs]='./"." | first | strptime("%Y-%m-%dT%H:%M:%S") | mktime'
with.md:# Count syslog lines by hours
with.md:jq[by-hours]='map(gmtime) | group_by(.[3]) | map(length)[]'
with.md:
with.md:# Use jq code associated with a func
with.md:jqf () { jq -M "${jq[${FUNCNAME[1]}]}" "$@"; }
with.md:
with.md:# All compressed and uncompressed syslog files concatenated
with.md:syslogs () { zgrep . /var/log/syslog* | cut -d: -f2-; }
with.md:
with.md:# Use our jq code
with.md:epochs () { syslogs | jqf -R | sort -n; }
with.md:by-hours () { epochs | jqf -s; }
with.md:```
with.md:
with.md:## Play it on remote node
with.md:
with.md:- use `with`
with.md:
with.md:```bash
with.md:source with.sh
with.md:lib=(jq jqf syslogs epochs by-hours)
with.md:```
with.md:
with.md:- Call a specific func (e.g. for testing)
with.md:
with.md:```bash
with.md:with ${lib[@]} -- syslogs | ssh localhost -l root bash | head
with.md:```
with.md:
with.md:- Default to call the last arg of `with`
with.md:
with.md:```console
with.md:$ with ${lib[@]} | ssh localhost -l root bash | fmt
with.md:1463 689 415 421 420 681 494 770 1267 7902 1920 849 2064 2091 5199 1401
with.md:758 1282 4990 4468 1692 1037 1013 1093
with.md:```
with.md:
with.md:## Add a local minimal plot
with.md:
with.md:- See [zoom.jq][]
with.md:
with.md:```bash
with.md:with ${lib[@]} | ssh localhost -l root bash | jq -sr 'include "zoom"; plot(sqrt; 80; 20)'
with.md:```
with.md:
with.md:---
with.md:
with.md:```
with.md:                              ███                                               
with.md:                              ███                                               
with.md:                              ███                                               
with.md:                              ███                                               
with.md:                              ███              ███          ███                 
with.md:                              ███              ███          ██████              
with.md:                              ████             ███          ██████              
with.md:                              ████            ████          ███████             
with.md:                              ████            ████          ███████             
with.md:                              ████            ████          ███████             
with.md:                              ██████    ██████████          ███████             
with.md:███                           ███████   ██████████          ██████████          
with.md:███                        ██████████   █████████████    █████████████          
with.md:████                      ████████████████████████████  ████████████████████████
with.md:███████          ███   █████████████████████████████████████████████████████████
with.md:████████████████████████████████████████████████████████████████████████████████
with.md:████████████████████████████████████████████████████████████████████████████████
with.md:████████████████████████████████████████████████████████████████████████████████
with.md:████████████████████████████████████████████████████████████████████████████████
with.md:████████████████████████████████████████████████████████████████████████████████
with.md:```
with.md:
with.md:[zoom.jq]: zoom.jq "sibling file"
with.md:
func-on-one-line.md:# Output func on one line
func-on-one-line.md:
func-on-one-line.md:- See [func-on-one-line.sh][]
func-on-one-line.md:- Aliased as `func`
func-on-one-line.md:- Argument of alias is expanded (so that `func func` is exanped as
func-on-one-line.md:  `func-on-one-line func-on-one-line`)
func-on-one-line.md:
func-on-one-line.md:```console
func-on-one-line.md:$ source func-on-one-line.sh
func-on-one-line.md:$ func func
func-on-one-line.md:func-on-one-line () { local -n a=MAPFILE; mapfile -t < <(declare -f ${1:?}); ((${#a[*]})) || return 1; local i t; for ((i = 2; i < $((${#a[*]} - 1)); ++i)) do t=${a[(($i + 1))]}; printf -v n -- ${t/\%/%%}; [[ ${#n} == 1 && ${n:(-1)} == "}" ]] || [[ ${#n} == 2 && ${n:(-2)} == "};" ]] && a[$i]+=";"; done; a[-1]+=';'; echo ${a[@]}; };
func-on-one-line.md:```
func-on-one-line.md:[func-on-one-line.sh]: func-on-one-line.sh "sibling file"
func-on-one-line.md:
func-on-one-line.md:# Allow easy copy-paste and on the fly edition
func-on-one-line.md:
func-on-one-line.md:```console
func-on-one-line.md:source <(func func | sed s/^func-on-one-line/fool/)
func-on-one-line.md:```
func-on-one-line.md:
misc.md:# Misc funcs
misc.md:
misc.md:- See [misc.sh][]
misc.md:
misc.md:```bash
misc.md:files=(with func-on-one-line misc)
misc.md:sources () { for file in ${files[@]}; do source $file.sh; done; }
misc.md:funcs () { for file in ${files[@]}; do $file.list; done; }
misc.md:```
misc.md:
misc.md:```console
misc.md:$ sources; funcs | loop args | loop func
misc.md:with () { until [[ $# == 1 || $1 == -- ]]; do with.decl $1; shift; done; if [[ $1 == -- ]]; then shift; fi; with.decl $1; echo $@; };
misc.md:with.decl () { declare -p $1 &> /dev/null && declare -p $1; declare -f $1; };
misc.md:func-on-one-line () { local -n a=MAPFILE; mapfile -t < <(declare -f ${1:?}); ((${#a[*]})) || return 1; local i t; for ((i = 2; i < $((${#a[*]} - 1)); ++i)) do t=${a[(($i + 1))]}; printf -v n -- ${t/\%/%%}; [[ ${#n} == 1 && ${n:(-1)} == "}" ]] || [[ ${#n} == 2 && ${n:(-2)} == "};" ]] && a[$i]+=";"; done; a[-1]+=';'; echo ${a[@]}; };
misc.md:args () { for arg in "$@"; do echo $arg; done; };
misc.md:loop () { while read; do eval "$@" $REPLY; done; };
misc.md:```
misc.md:
misc.md:[misc.sh]: misc.sh "sibling file"
misc.md:
bash-from-md.md:# Extract bash stanzas from mardown files
bash-from-md.md:
bash-from-md.md:- To be used as `source <(< file.md bash-from-md)`
bash-from-md.md:- But we need a way to name stanzas
bash-from-md.md:- Maybe something like
bash-from-md.md:
bash-from-md.md:```bash
bash-from-md.md:: name=example
bash-from-md.md:example=42
bash-from-md.md:```
bash-from-md.md:
bash-from-md.md:- Then we could use `source <(< bash-from-md.md bash-from-md example)`
bash-from-md.md:
bash-from-md.md:## Funcs
bash-from-md.md:
bash-from-md.md:```bash
bash-from-md.md:declare -A awk=()
bash-from-md.md:awk[bash-from-md]='BEGIN { i = 0 } /^```bash/ { ++b; next } /^```$/ { --b; ++i } '
bash-from-md.md:awk[bash-from-md]+='b { t[i] = t[i] $0 RS } END { print t[n] }'
bash-from-md.md:
bash-from-md.md:awkf () { awk "$@" "${awk[${FUNCNAME[1]}]}"; }
bash-from-md.md:
bash-from-md.md:bash-from-md () { awkf -v n=${1:-0}; }
bash-from-md.md:```
bash-from-md.md:
bash-from-md.md:## Play
bash-from-md.md:
bash-from-md.md:```console
bash-from-md.md:$ < with.md bash-from-md
bash-from-md.md:declare -A jq=()
bash-from-md.md:# Get epochs from syslog lines
bash-from-md.md:jq[epochs]='./"." | first | strptime("%Y-%m-%dT%H:%M:%S") | mktime'
bash-from-md.md:# Count syslog lines by hours
bash-from-md.md:jq[by-hours]='map(gmtime) | group_by(.[3]) | map(length)[]'
bash-from-md.md:
bash-from-md.md:# Use jq code associated with a func
bash-from-md.md:jqf () { jq -M "${jq[${FUNCNAME[1]}]}" "$@"; }
bash-from-md.md:
bash-from-md.md:# All compressed and uncompressed syslog files concatenated
bash-from-md.md:syslogs () { zgrep . /var/log/syslog* | cut -d: -f2-; }
bash-from-md.md:
bash-from-md.md:# Use our jq code
bash-from-md.md:epochs () { syslogs | jqf -R | sort -n; }
bash-from-md.md:by-hours () { epochs | jqf -s; }
bash-from-md.md:
bash-from-md.md:$ < with.md bash-from-md 1
bash-from-md.md:source with.sh
bash-from-md.md:lib=(jq jqf syslogs epochs by-hours)
bash-from-md.md:```
bash-from-md.md:
