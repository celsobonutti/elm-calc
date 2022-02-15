module Expr exposing (..)

import AssocList as Dict exposing (Dict)
import Currency exposing (Currency)
import Tuple exposing (first, mapBoth, second)


type Identifier
    = Identifier String


type Expr
    = Assign { id : Identifier, value : Expr }
    | Sum Expr Expr
    | Mul Expr Expr
    | Money Int Currency
    | Id Identifier


type alias VariableMap =
    Dict Identifier Int


insertMaybe : Identifier -> Maybe Int -> VariableMap -> VariableMap
insertMaybe id result =
    case result of
        Just value ->
            Dict.insert id value

        Nothing ->
            identity


runState : VariableMap -> Expr -> ( Maybe Int, VariableMap )
runState variables expr =
    let
        eval =
            evalState variables
    in
    case expr of
        Assign { id, value } ->
            ( Nothing, insertMaybe id (eval value) variables )

        Sum x y ->
            case mapBoth eval eval ( x, y ) of
                ( Just n, Just m ) ->
                    ( Just <| n + m, variables )

                _ ->
                    ( Nothing, variables )

        Mul _ _ ->
            Debug.todo "TODO"

        Money x _ ->
            ( Just x, variables )

        Id identifier ->
            ( Dict.get identifier variables, variables )


evalState : VariableMap -> Expr -> Maybe Int
evalState variables =
    runState variables >> first


execState : VariableMap -> Expr -> VariableMap
execState variables =
    runState variables >> second
