module Expr.Parser exposing (..)

import Currency exposing (Currency(..))
import Expr exposing (Expr(..), Identifier(..), Measure(..))
import Parser exposing (..)
import Set


expr : Parser Expr
expr =
    oneOf [ backtrackable number
          , backtrackable assignment
          ]


number : Parser Expr
number =
    oneOf
        [ backtrackable money
        , backtrackable <| succeed (\n -> Number n Nothing) |= int
        ]


var : Parser Identifier
var =
    succeed Identifier
        |= variable
            { start = Char.isAlpha
            , inner = Char.isAlphaNum
            , reserved = Set.fromList [ "is", "in" ]
            }


assignment : Parser Expr
assignment =
    succeed (\id value -> Assign { id = id, value = value })
        |= var
        |. spaces
        |. oneOf [ keyword "=", keyword "is" ]
        |. spaces
        |= lazy (\_ -> expr)


money : Parser Expr
money =
    oneOf <|
        List.map backtrackable
            [ succeed Number |= int |. spaces |= (succeed Just |= currency)
            , succeed Number |. symbol "$" |. spaces |= int |= succeed (Just <| C USD)
            , succeed Number |= int |= succeed (Just <| C USD) |. spaces |. symbol "$"
            ]


currency : Parser Measure
currency =
    let
        toParser : Currency -> Parser Measure
        toParser c =
            succeed (C c) |. symbol (Currency.toString c)
    in
    Currency.possibilities
        |> List.map toParser
        |> oneOf
