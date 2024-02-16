shopt -s extglob

func-on-one-line () 
{ 
    local -n a=MAPFILE;
    mapfile -t < <(declare -f ${1:?});
    ((${#a[*]})) || return 1;
    local i t;
    for ((i = 2; i < $((${#a[*]} - 1)); ++i))
    do
        t=${a[(($i + 1))]};
        printf -v n -- ${t/\%/%%};
        [[ ${#n} == 1 && ${n:(-1)} == "}" ]] || [[ ${#n} == 2 && ${n:(-2)} == "};" ]] && a[$i]+=";";
    done;
    a[-1]+=';';
    a=("${a[@]% }");
    echo "${a[@]##*( )}";
}
alias func='func-on-one-line '

item () { declare -p $1 &> /dev/null && declare -p $1; func $1; }

func-on-one-line.list () { echo func-on-one-line item; }
