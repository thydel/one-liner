# Scale up or down an array of number
# Simple but not space optimmal (need product of in and out arrays size)

def zoom($n):
  length as $l
  | [.[] as $i | range($n) | $i] as $i
  | [ range($n) | $i[. * $l : . * $l + $l] | add / $l];

# Scale up or down an array of number
# Same idea but simulate a pipe (only need sum of in and out arrays size)

def scale($sizout):
  length as $sizin |
  { in: ., out: [], inside: $sizout, wanted: $sizin, valout: 0 }
  | until(
        .in == [];
	if .wanted > .inside
	then
          .valout += .in[0] * .inside
          | .in |= .[1:]
          | .wanted -= .inside
          | .inside = $sizout
	else
          .out += [(.valout + .in[0] * .wanted) / $sizin]
          | .valout = 0
          | .inside -= .wanted
          | .wanted = $sizin
        end
        ).out;

# Use zoom to plot an array

def norm($ceil): max as $max | map(. / $max * $ceil | round);
def plot: map([range(.)]) | transpose | map(map(if . == null then "\u2591" else "\u2588" end) | add) | reverse[];
def plot(f; $x; $y): scale($x) | map(f) | norm($y) | plot;
def plot($x; $y): plot(.; $x; $y);
