{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Rule where

import Data.Text
import Control.Monad.Writer

import Selector hiding (Child)
import Property

data Rule
  = Self     Filter
  | Root     Selector
  | Pop  Int
  | Child    Selector
  | Sub      Selector

newtype Rules = Rules [Either (Text, Text) (Rule, Rules)]
  deriving Monoid

type Css = Writer Rules ()

infix 4 -:

key :: Val a => Key a -> a -> Css
key (Key k) v = tell (Rules [Left (k, unValue (value v))])

key2 :: (Val a, Val b) => Key (a, b) -> a -> b -> Css
key2 k a b = key k (a, b)

key3 :: (Val a, Val b, Val c) => Key (a, b, c) -> a -> b -> c -> Css
key3 k a b c = key k (a, b, c)

key4 :: (Val a, Val b, Val c, Val d) => Key (a, b, c, d) -> a -> b -> c -> d -> Css
key4 k a b c d = key k (a, b, c, d)

(-:) :: Key Text -> Text -> Css
(-:) = key

self :: Filter -> Css -> Css
self p rs = tell (Rules [Right (Self p, execWriter rs)])

root :: Selector -> Css -> Css
root sel rs = tell (Rules [Right (Root sel, execWriter rs)])

pop :: Int -> Css -> Css
pop i rs = tell (Rules [Right (Pop i, execWriter rs)])

child :: Selector -> Css -> Css
child sel rs = tell (Rules [Right (Child sel, execWriter rs)])

rule :: Selector -> Css -> Css
rule sel rs = tell (Rules [Right (Sub sel, execWriter rs)])
