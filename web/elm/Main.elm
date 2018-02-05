module Main exposing (..)

import Html exposing (..)


type alias Flag =
    { userAccount : Maybe String }


type alias Model =
    { userAccount : Maybe String }


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
    ( { userAccount = flags.userAccount }, Cmd.none )


initialModel =
    {}


view model =
    div []
        [ h1 [] [ text "Coin blog" ]
        , showUserAccount model
        ]


showUserAccount model =
    case model.userAccount of
        Just userAccount ->
            div [] [ text userAccount ]

        Nothing ->
            div [] [ text "No account detected" ]


update msg model =
    ( model, Cmd.none )


subscriptions model =
    Sub.none
