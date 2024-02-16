# b in bash stanza
# s stanza name
/^```bash/ { ++b; next }
b && /^: name=/ { FS = "="; $0 = $0; s = $2 }
/^```$/ { --b; s = "" }
b && s { t[s] = t[s] $0 RS }
END { print t[n] }
