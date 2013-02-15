-- Copyright (c) 2013 Bart Massey
-- Reconstruction of `foldlr` primitive.

import Data.Function (fix)

foldlr :: (l -> x -> r -> (l, r)) -> l -> r -> [x] -> (l, r)
foldlr _ l r0 [] = (l, r0)
foldlr f l r (x : xs) =
  let (l', r') = f l x r''
      (l'', r'') = foldlr f l' r xs in
  (l'', r')

foldl :: (a -> x -> a) -> a -> [x] -> a
foldl f a0 xs =
  fst $ foldlr (\l x _ -> (f l x, undefined)) a0 undefined xs

foldr :: (x -> a -> a) -> a -> [x] -> a
foldr f a0 xs =
  snd $ foldlr (\_ x r -> (undefined, f x r)) undefined a0 xs

mapAccumL :: (a -> x -> (a, y)) -> a -> [x] -> (a, [y])
mapAccumL f a0 xs =
  foldlr g a0 [] xs
  where
    g l x r =
      let (l', y) = f l x in
      (l', y : r)

sumSum :: [Int] -> (Int, [Int])
sumSum xs = mapAccumL (\a x -> (a + 1, a + x)) 0 xs

fl :: Int -> Int -> Int -> (Int, Int)
fl l x r | l > 0 = (l + 1, r + 1)

fr :: Int -> Int -> Int -> (Int, Int)
fr l x r | r > 0 = (l + 1, r + 1)

flr :: Int -> Int -> Int -> (Int, Int)
flr l x r | l > 0 && r > 0 = (l + 1, r + 1)

fold :: ((l, r) -> x -> (l, r)) -> (l, r) -> [x] -> (l, r)
fold _ ~(l, r0) [] = (l, r0)
fold f (l, r) (x : xs) =
  let (l', r') = f (l, r'') x
      (l'', r'') = fold f (l', r) xs in
  (l'', r')


foldr_ :: (x -> a -> a) -> a -> [x] -> a
foldr_ f a0 xs = 
  let (a, _) = (fix foldr_') (a0, xs) in a
  where
    foldr_' g (a, []) = (a, undefined)
    foldr_' g (a, x : xs) = g (f x a, xs)

foldr__ :: (x -> a -> a) -> a -> [x] -> a
foldr__ f a0 xs =
  let (a, _) = foldr__' (a0, xs) in a
  where
    foldr__' (a, []) = (a, undefined)
    foldr__' (a, x : xs) = foldr__' (f x a, xs)
