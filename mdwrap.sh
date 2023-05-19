#!/bin/sh
# Copyright © 2013 Bart Massey
# HTML-wrap markdown output for slides
USAGE="usage: mdwrap <file>.md"
if [ $# -ne 1 ]
then
    echo "$USAGE" >&2
    exit 1
fi
case "$1" in
*.md)
    F="`basename \"$1\" .md`"
    ;;
*)
   echo "$USAGE" >&2
   exit 1
esac
cat <<EOF
<html><head>
<title>lr / Data.List</title>
<link rel="stylesheet" type="text/css" href="plclub.css">
</head><body>
EOF
markdown "$F".md
cat <<EOF
</body></html>
EOF
