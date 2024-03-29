#!/bin/sh
# Copyright © 2013 Bart Massey
# Generate Data.List.Combinator dependency graph.
sh mkmkgraph.sh ../Data-List-Combinator.hs >mkgraph.awk &&
( echo "digraph \"Dependencies in Data.List.Combinator\" {" &&
  awk -f mkgraph.awk <../Data-List-Combinator.hs | ./nub &&
  echo "}" ) >graph.dot &&
dot -Tsvg graph.dot >graph.svg
