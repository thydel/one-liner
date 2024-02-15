args () { for arg; do echo $arg; done; }
loop () { while read; do eval "$@" $REPLY; done }

misc.list () { echo args loop; }
