# A General Linear Recursion Operator vs Data.List
Bart Massey  
PL Club 2013-02-14

## A WIP Story

This story goes back a ways. In 2010

* I get interested in `Data.List.mapAccumL`, because it appears to
  be not obviously expressible as `foldl` or `foldr`.

* The key seems to be that it carries data from the left like
  `foldl` (the "accumL" part), but should be implemented
  like `map` with a `foldr`.

* Jamey Sharp, Julian Kongslie and I become interested in
  whether there's some kind of "both ways at once" fold that would
  apply here: laziness seems to make it possible.

## Introducing `foldlr`

After some messing around, the thing that the types kind of
force seems to make sense:

* While traversing the list from the left, carry along
  a left accumulator. Have it "meet" an accumulator "travelling
  from the right", that will be started when the end of the
  list is reached.

* Thus, this fold can make use of some information from
  the past, and some "from the future", thanks to laziness.

* The result looks like [this](foldlr.hs.html).

## Some properties of `foldlr`

* `foldl` and `foldr` are trivially
  [implementable](foldlr.hs.html) as `foldlr`.

* `mapAccumL` is implementable as `foldlr`.
