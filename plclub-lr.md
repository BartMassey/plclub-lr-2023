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

* Strictness of `foldlr` depends on strictness of folding
  function `f`: strict if `f` is strict on at most one of
  the right or left accumulator, bottom if `f` is strict on
  both.

## Related Work

* Noah Easterly's
  "[bifold](http://haskell.1045720.n5.nabble.com/Bifold-a-simultaneous-foldr-and-foldl-td3285581.html)"
  from Haskell-Cafe is identical up to trivial signature
  differences

* I do not understand whether Henning Theielemann's
  "foldl'r" discussed there is the same.

* Probably others also.

## An SE Plan

I've always liked the idea of supercombinator
programming. In particular, the promise of getting rid of
non-sequential control flow is that it intuitively seems
likely to get rid of control flow bugs:

> gotos &#8594; loops &#8594; recursion &#8594; nothing

Parts of `Data.List` are written in terms of each other, but
a lot are "optimized" loops. Try rewriting everything in
terms of `foldlr`?

## (Notational Switch)

An aside: the type signature and usage of `foldlr` is kind
ugly. After some messing around, I ended up with
[this](foldlr.hs.html) `fold`.

## `Data.List.Combinator` -- The Big Rewrite

Some months later I had a working copy of `Data.List`
rewritten in terms of `fold`, `unfoldr`, and one data
recursion (`cycle`).

* The rewrite was a sort of "cheat". In several places
 (`transpose` and `sort` come to mind) I constructed an
 internal list whose sole purpose was structural, to run
 `fold` over. The list contents were ignored or marginally
 useful.

* Having `unfoldr` lying around separately seemed no good.

* Started to expose one possible set of dependencies between
  `Data.List` functions.

* Added about 25 functions for completeness, orthogonality,
  general goodness: total about 135 functions.

## Laws

To try to ensure that I was doing the rewrite fairly, I
constructed "laws" for almost all functions in `Data.List`.

* Also specified complexity and strictness.

* Laws (and code) were constructed solely from the
  documentation.

* Did some very minimal verification that some laws held for
  both versions.

* Found one fairly glaring bug in the documentation, in
  [insertBy](Data-List-Combinator.hs.html).
  ([Bug #7421](http://hackage.haskell.org/trac/ghc/ticket/7421),
  now fixed).

* Some laws are missing, likely still buggy.

## Phase 2: Now With Even More Supercombinators

Over the recent Christmas break I started getting interested
in what cleanups were possible. I started thinking about the
general structure of linear recursion, and decided that the
list argument of `fold` is unnecessary.

* Constructed a more general
  [operator](Data-List-Combinator.hs.html) `lr`, for
  "linear recursion" (stupid name?), which handwavingly
  generalizes any linear recursive function.

* Constructed by essentially ripping the list out of `fold`,
  leaving only the structure. This means that a way to stop
  recursing was desirable; a `Maybe` on the right argument
  did the trick.

* The result looks more like `unfold`, and for a while I
  called it that.

## The Power of `lr`

* Provides "natural" (?) implementations of `fold`, and of
  `unfoldr` and `unfoldl` (just ignoring left or right as
  with `foldl` and `foldr`).

* Contrast with `fix`, which does a sort of
  "Recursion-removal In Name Only" [RINO](foldlr.hs.html)".

* Contrast with `fold`, which is stuck down to lists.

## The Structure of `Data.List.Combinator`

It is interesting to look at the
[dependency graph](graph/graph.svg)
of the resulting `Data.List.Combinator`.

* Of course, this is only one possible way of doing
  things. My Haskell skills are not so leet...

* Note how much of the library is in terms of just a few
  primitive functions.

## Some Lazy Pattern Matches

In several places, pattern matches had to be made "lazy" (~
operator) to get strictness right.

* Typical case was an "irrefutable" pattern match: wanted to
  be deferred for laziness because there was only one way it
  could match. e.g. in `transpose`

        g ~(y : ys) (h, t) = (y : h, ys : t)

* Maybe this should be implicit?  I had nice discussions
  with Tim Sheard and Mark Jones about this. They both think
  that this is fine.

* Mark actually managed to convince me for a while.

         f ~[_] = 3

         >>> f []
         3

  * Now I am not convinced again: this seems OK to me.

## One Strictness Bug

There is one known outright strictness bug. There are probably
many others.

* Bug manifests in `take`.

        >>> take 1 $ insertBy compare 2 [1, undefined]
        [1*** Exception: Prelude.undefined

* Seems like something deep, and I can't find it.

* Strange behavior in that take "shouldn't be able to do that".

## Performance Sucks

The performance of all this? The same 30x slower that was
reported last week. And probably for the same reasons.

* Did some Criterion [benchmarks](benchmarks.html)

## Work In Progress

* Fix known bugs.

* Find or write `Data.List` QuickCheck or similar tests.

* Use a strictness tester to find more strictness bugs.

* Nail down the rest of the Laws.

* Experiment with actual proofs in this structure.

* Make performance acceptable if possible.

* Figure out how to fuse `lr` calls.

## Acknowledgments

* Jamey Sharp and Julian Kongslie, who helped me work
  through this the first time.

* Mark Jones and Tim Sheard, who had great comments on
  everything.

* The PDXFunc folks, who listed to two versions of this talk
  and provided valuable feedback.

* Graphviz and Criterion
