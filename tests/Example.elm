module Example exposing (..)

import Expr.Parser exposing (money)
import Parser
import Expr
import Expect
import Test exposing (..)
import Currency exposing (Currency(..))

exprParsing : Test
exprParsing =
    describe "The parser"
        [ describe "money"
            [ test "is parsed correctly when explicitly using currency" <|
                \_ ->
                    let parsed = Parser.run money "25BRL" in
                    Expect.equal parsed (Ok <| Expr.Money 25 BRL)
            , test "infers USD when not using a currency" <|
                \_ ->
                    let parsed = Parser.run money "1000" in
                    Expect.equal parsed (Ok <| Expr.Money 1000 USD)
            ]
        ]
