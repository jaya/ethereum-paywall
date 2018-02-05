module Main exposing (..)

import Html exposing (..)


type alias Flag =
    {}


type alias Model =
    {}


type Msg
    = NoOp


main =
    programWithFlags
        { view = view
        , update = update
        , subscriptions = subscriptions
        , init = init
        }


init : Flag -> ( Model, Cmd Msg )
init flags =
    ( initialModel, Cmd.none )


initialModel =
    {}


view model =
    div [] []


update msg model =
    ( model, Cmd.none )


subscriptions model =
    Sub.none
