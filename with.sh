with.decl () { declare -p $1 &> /dev/null && declare -p $1; declare -f $1; }
alias decl=with.decl
with () { until [[ $# == 1 || $1 == -- ]]; do decl $1; shift; done; if [[ $1 == -- ]]; then shift; fi; decl $1; echo $@; }
unalias decl

with.list () { echo with; }
