module Main exposing (..)

import Browser
import Expr
import Html exposing (Html, div, p, text, textarea)
import Html.Attributes as Attr
import Expr.Parser exposing (parse)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { input : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { input = "Memes" }
    , Cmd.none
    )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd msg )
update _ model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ textarea [ Attr.value model.input ] []
        , p [] [ text model.input ]
        ]

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
