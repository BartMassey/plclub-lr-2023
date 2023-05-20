# Data.List.Combinators: A Post-Mortem
Bart Massey  
PL Club 2023-05-19

## Talk Outline

* Describe the overall project

* Set some expectations

* Look at the old talk in parallel with comments here

* Pose a whole bunch of questions

## The Data.List.Combinators Project

* In 2012 or so I was fooling around with "fancy" combinators
  
* I conceived the idea of expressing all of (pre-FTP)
  `Data.List` as pure combinator functions atop a single
  recursive function. It sounded like fun, so I did it
  (with a bunch of help from others).

* The goal was to produce clones with maximal laziness (per
  the original, I think) and identical behavior. One barrier
  was the lack of "formal" (small-F) specification of the
  original. So I wrote "Laws" for most of the functions.

## Project Results: Summary

* The result was as expected: (very) slow, kind of ugly and
  weird in spots, an unfixed bug
  
* Was a proof of possibility; found and fixed a bug in the library
  documentation 

* Exposed some possibilities for new `Data.List` functions

## About This Work

* *Never* run down your own skills or work at the start of a
  talk. It sets a horrible expectation for the
  listeners. Terrible form.

* Having said that…

  * I am not particularly competent at "modern" FP. Please
    correct my many mistakes.

  * This work appears pretty naïve given current
    understanding of fancy morphisms. Help appreciated.

  * There's a lot here that never got properly finished.

## Cunningham's Law

* The best way to get a right answer on the Internet is to
  post a wrong answer
  
* My story about this

## Reconstructing The Work: Rebuilding

* Building `Data.List.Combinators` on GHC 9 failed with a
  compiler panic trying to build `Test.QuickCheck.Random`
  for QuickCheck-2.14.2

        ghc: panic! (the 'impossible' happened)
          (GHC version 9.0.2:
            Ix{Int}.index: Index (2504331244) out of range ((0,821))

  Fortunately GHC 8 worked. I am shocked at how easy it was
  to clean up some minor `.cabal` issues and build without
  warnings or errors.

* Reran the benchmarks. Relative performance was similar to
  2013 (GHC 5)

## Reconstructing The Work: Remembering

* Found my 2013 talk notes, thank goodness. Not sure what I
  would have done otherwise.

* Some tools and techniques I used to put the talk together
  took some re-figuring. Glad I used a `Makefile`.
  
## 2013 Talk: foldlr and lr

* Thanks to Katie Casamento for encouraging me to check out
  modern morphism stuff. I found this 2014 blog post series
  by Paul Thomson
  
  https://blog.sumtypeofway.com/posts/introduction-to-recursion-schemes.html

  that seems great: still digesting

* I think `foldlr` is some standard catamorphism and `lr` is
  some standard hylomorphism? Idk about `fold`

## 2013 Talk: SE

* Most of the functions are built on top of the "big three":
  `foldl`, `foldr`, `unfoldr`. I suspect that's partly
  because of my naïvety about how the fancy functions can be
  used. Is that the whole story?

* The new functions are interesting, in the sense that maybe
  they are reasonable to add. Should look into it?
  
* An aside: libraries *very much vs* applications — c.f. `lrbench`.
  How much can / should we expect of library authors? Of
  application authors?

## 2013 Talk: Laws

* How should Laws be specified for Haskell functions? Is
  this the right "syntax"?

* Strictness is important but I know of no good way to
  specify strictness short of "maximally lazy" and some
  English. Ideas?

* Time complexity is a bit ill-defined for Haskell? Or no?
  Laziness makes reasoning about it confusing.

* Space complexity is a problem. Any good way to get insight
  on memory usage for "garbage cons cells" or similar?

## 2013 Talk: Lazy Pattern Matching

* Is this an actual issue? I don't think folks "normally" teach
  lazy matching to new Haskell users, although I think our
  FP course covers it

## Performance?

* Does performance matter here? Are there ways to make the
  whole structure more performant?
  
* How much of the performance problem is just my lack of
  understanding of Haskell operational semantics? Can we
  reasonably expect such understanding from "line programmers"?

* Is the lazy matching part of the performance issue?

* How much should we expect GHC to be able to do for us
  going forward?

## FTP?

* Post this work, the "Functional Traversable Proposal" was
  adopted for `Data.List`, making it more `Data.FT`
  
* Was this good or am I wrong? Change my mind: making
  `Maybe` FT is more of a footgun than a feature

* How would this affect continuing this project?

## Is This A Thing?

* "I did a thing"

* Is there anything here worth continuing / salvaging?

  * Probably some kind of laws, I think. Proofs?

  * Maybe continued GHC improvements for combinators, but
    this seems to be incredibly hard?

## Freaking Eloi and Morlocs

* c.f. *The Time Machine*. I am not an H.G. Wells fan. Maybe
  Architects and Builders?

* "Avoid success at any cost" has been incredibly successful

* ChatGPT programming vs brilliant elegant programming?

## Acks and Source

* Thanks to the original ackees, to Katherine Phillips for
  inviting the talk, and to Katie Casamento for the helpful
  suggestion about morphisms
  
* https://github.com/BartMassey/plclub-lr-2023

* https://github.com/BartMassey/list-combinators
