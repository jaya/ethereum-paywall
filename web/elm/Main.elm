module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Coin exposing (..)
import PurchaseInfo exposing (PurchaseInfo)


type alias Flag =
    { userAccount : Maybe String, contractAddress : Maybe String }


type alias Model =
    { userAccount : Maybe String
    , contractAddress : Maybe String
    , userBalance : Maybe Float
    }


type Msg
    = NoOp
    | SetUserBalance Float
    | PurchaseCoins PurchaseInfo


main =
    programWithFlags
        { view = view
        , update = update
        , subscriptions = subscriptions
        , init = init
        }


init : Flag -> ( Model, Cmd Msg )
init flags =
    let
        m =
            initialModel flags

        c =
            initialCommands m
    in
        ( m, c )


initialCommands model =
    case model.userAccount of
        Just userAccount ->
            Cmd.batch [ getUserBalance userAccount ]

        Nothing ->
            Cmd.none


initialModel flags =
    { userAccount = flags.userAccount
    , contractAddress = flags.contractAddress
    , userBalance = Nothing
    }


view model =
    div []
        [ h1 [] [ text "Coin blog" ]
        , showUserAccount model
        , showContractAddress model
        , showPurchaseWidget model
        ]


showPurchaseWidget model =
    case ( model.userAccount, model.contractAddress ) of
        ( Just userAccount, Just contractAddress ) ->
            div []
                [ button
                    [ onClick
                        (PurchaseCoins
                            { contractAddress = contractAddress
                            , userAccount = userAccount
                            }
                        )
                    ]
                    [ text "Purchase coins!" ]
                ]

        _ ->
            div [] []


showUserAccount model =
    case ( model.userAccount, model.userBalance ) of
        ( Just userAccount, Just userBalance ) ->
            div []
                [ text userAccount
                , text " and your balance is "
                , text (toString userBalance)
                ]

        ( Just userAccount, Nothing ) ->
            div []
                [ text userAccount
                , text " and we are still fetching your balance"
                ]

        _ ->
            div [] [ text "No account detected" ]


showContractAddress model =
    case model.contractAddress of
        Just contractAddress ->
            div [] [ text contractAddress ]

        Nothing ->
            div [] [ text "No contract address provided" ]


update msg model =
    case msg of
        SetUserBalance balance ->
            ( { model | userBalance = Just balance }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        PurchaseCoins account ->
            ( model, purchaseCoins account )


subscriptions model =
    Sub.batch
        [ setUserBalance SetUserBalance
        ]
