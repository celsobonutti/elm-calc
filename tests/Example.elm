module Example exposing (..)

import Currency exposing (Currency(..))
import Expect
import Expr exposing (Identifier(..), Measure(..))
import Expr.Parser exposing (expr)
import Parser
import Test exposing (..)


exprParsing : Test
exprParsing =
    describe "The parser"
        [ describe "numbers"
            [ describe "money"
                [ test "is parsed correctly when explicitly using currency" <|
                    \_ ->
                        let
                            parsed =
                                Parser.run expr "25BRL"
                        in
                        Expect.equal parsed (Ok <| Expr.Number 25 (Just <| C BRL))
                , test "infers USD when using $ after number" <|
                    \_ ->
                        let
                            parsed =
                                Parser.run expr "1000 $"
                        in
                        Expect.equal parsed (Ok <| Expr.Number 1000 (Just <| C USD))
                , test "infers USD when using $ before number" <|
                    \_ ->
                        let
                            parsed =
                                Parser.run expr "$2500"
                        in
                        Expect.equal parsed (Ok <| Expr.Number 2500 (Just <| C USD))
                ]
            , describe "with no measures"
                [ test "are parsed correctly" <|
                    \_ ->
                        let
                            parsed =
                                Parser.run expr "150"
                        in
                        Expect.equal parsed (Ok <| Expr.Number 150 Nothing)
                ]
            ]
        , describe "assingments"
            [ test "work with the `is` keyword" <|
                \_ ->
                    let
                        parsed =
                            Parser.run expr "memes is 25"
                    in
                    Expect.equal parsed <|
                        Ok <|
                            Expr.Assign
                                { id = Identifier "memes"
                                , value = Expr.Number 25 Nothing
                                }
            , test "work with the = sign" <|
                \_ ->
                    let
                        parsed =
                            Parser.run expr "bozzano = 15$"
                    in
                    Expect.equal parsed <|
                        Ok <|
                            Expr.Assign
                                { id = Identifier "bozzano"
                                , value = Expr.Number 15 (Just <| C USD)
                                }
            ]
        ]
