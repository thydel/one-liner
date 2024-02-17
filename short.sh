source with.sh
source func-on-one-line.sh
source <(func with | sed -e s/^with/short/ -e s/with.decl/item/g)

short.list () { echo func-on-one-line item short; }

