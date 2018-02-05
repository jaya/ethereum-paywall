module Main exposing (..)

import Html exposing (..)


type alias Flag =
    { userAccount : Maybe String, contractAddress : Maybe String }


type alias Model =
    { userAccount : Maybe String, contractAddress : Maybe String }


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
    ( { userAccount = flags.userAccount
      , contractAddress = flags.contractAddress
      }
    , Cmd.none
    )


initialModel =
    {}


view model =
    div []
        [ h1 [] [ text "Coin blog" ]
        , showUserAccount model
        , showContractAddress model
        ]


showUserAccount model =
    case model.userAccount of
        Just userAccount ->
            div [] [ text userAccount ]

        Nothing ->
            div [] [ text "No account detected" ]


showContractAddress model =
    case model.contractAddress of
        Just contractAddress ->
            div [] [ text contractAddress ]

        Nothing ->
            div [] [ text "No contract address provided" ]


update msg model =
    ( model, Cmd.none )


subscriptions model =
    Sub.none
