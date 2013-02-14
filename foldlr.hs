-- Copyright (c) 2013 Bart Massey
-- Reconstruction of `foldlr` primitive.

foldlr :: (l -> x -> r -> (l, r)) -> l -> r -> [x] -> (l, r)
foldlr _ l r0 [] = (l, r0)
foldlr f l r (x : xs) =
  let (l', r') = f l x r''
      (l'', r'') = foldlr f l' r xs in
  (l'', r')

mapAccumL :: (a -> x -> (a, y)) -> a -> [x] -> (a, [y])
mapAccumL f a0 xs =
  foldlr g a0 [] xs
  where
    g l x r =
      let (l', y) = f l x in
      (l', y : r)

sumSum :: [Int] -> (Int, [Int])
sumSum xs = mapAccumL (\a x -> (a + 1, a + x)) 0 xs
