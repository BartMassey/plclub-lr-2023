-- Copyright (c) 2013 Bart Massey
-- Reconstruction of `foldlr` primitive.

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
