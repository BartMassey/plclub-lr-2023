-- Copyright © 2013 Bart Massey
-- Take the nub of lines in the input file.
-- Should really use nubOrd for long files.

import Data.List (nub)

main :: IO ()
main = interact (unlines . nub . lines)
