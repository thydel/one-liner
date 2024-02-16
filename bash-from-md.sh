declare -A awk=()
# Use next line to update `awk[bash-from-md]` if you change `bash-from-md.awk`
# < bash-from-md.awk jq -nRr '[inputs] | map(select(test("^#") | not)) | join(" ") | "awk[bash-from-md]=\(@sh)"'
awk[bash-from-md]='/^```bash/ { ++b; next } b && /^: name=/ { FS = "="; $0 = $0; s = $2 } /^```$/ { --b; s = "" } b && s { t[s] = t[s] $0 RS } END { print t[n] }'

awkf () { awk "$@" "${awk[${FUNCNAME[1]}]}"; }

bash-from-md () { awkf -v n=${1:?}; }

bash-from-md.list () { echo awkf bash-from-md; }
