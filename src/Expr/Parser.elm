module Expr.Parser exposing (..)

import Expr exposing (Expr(..))
import Currency exposing (Currency(..))
import Parser exposing (..)

expr : Parser Expr
expr = oneOf [ backtrackable money ]

money : Parser Expr
money =
    succeed Money
        |= int
        |= oneOf [ backtrackable (succeed identity |. spaces |= currency)
                 , succeed USD ]

currency : Parser Currency
currency =
    let
        toParser : Currency -> Parser Currency
        toParser c = succeed c |. symbol (Currency.toString c)
    in
        Currency.possibilities
        |> List.map toParser
        |> oneOf
