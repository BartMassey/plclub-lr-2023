#!/bin/sh
# Copyright © 2013 Bart Massey
# Emit an awk script to make a dependency graph for Data-List-Combinator.hs
STARTEXP="^[a-z][a-zA-Z0-9_']* ::"
echo "/$STARTEXP/ { curfn = \$1;  next; }"
echo "!curfn { next; }"
echo "/^[ 	]*--/ { next; }"
echo "/^[^ 	]/ { if (\$1 != curfn) next; }"
egrep "$STARTEXP" "$1" |
awk '{print $1;}' |
while read FN
do
	echo "/\\<$FN\\>/ { if (curfn != \"$FN\") printf \"  \\\"%s\\\" -> \\\"%s\\\";\\\\n\", curfn, \"$FN\"; }"
done
