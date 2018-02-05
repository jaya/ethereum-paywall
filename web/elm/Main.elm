module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Coin exposing (..)
import PurchaseInfo exposing (PurchaseInfo)
import UserCoinInfo exposing (UserCoinInfo)
import Debug exposing (log)
import Time exposing (Time, second)


type alias Flag =
    { userAccount : Maybe String, contractAddress : Maybe String }


type alias Model =
    { userAccount : Maybe String
    , contractAddress : Maybe String
    , userBalance : Maybe Float
    , userCoins : Maybe Float
    }


type Msg
    = NoOp
    | SetUserBalance Float
    | PurchaseCoins PurchaseInfo
    | TriggerUpdate ()
    | SetUserCoins (Maybe Float)
    | Tick Time


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
    case ( model.userAccount, model.contractAddress ) of
        ( Just userAccount, Just contractAddress ) ->
            Cmd.batch
                [ getUserBalance userAccount
                , getUserCoins
                    { contractAddress = contractAddress
                    , userAccount = userAccount
                    }
                ]

        _ ->
            Cmd.none


initialModel flags =
    { userAccount = flags.userAccount
    , contractAddress = flags.contractAddress
    , userBalance = Nothing
    , userCoins = Nothing
    }


view model =
    div []
        [ h1 [] [ text "Coin blog" ]
        , showUserAccount model
        , showContractAddress model
        , showPurchaseWidget model
        , showUserCoins model
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


showUserCoins model =
    case model.userCoins of
        Just userCoins ->
            div [] [ text "You have ", text (toString userCoins), text " coins" ]

        Nothing ->
            div [] [ text "We are fetching your amount of coins" ]


update msg model =
    case msg of
        SetUserBalance balance ->
            ( { model | userBalance = Just balance }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        PurchaseCoins account ->
            ( model, purchaseCoins account )

        TriggerUpdate () ->
            ( model, updateCommands model )

        SetUserCoins amount ->
            ( { model | userCoins = amount }, Cmd.none )

        Tick _ ->
            update (TriggerUpdate ()) model


updateCommands model =
    case ( model.contractAddress, model.userAccount ) of
        ( Just contractAddress, Just userAccount ) ->
            Cmd.batch
                [ getUserBalance userAccount
                , getUserCoins
                    { userAccount = userAccount
                    , contractAddress = contractAddress
                    }
                ]

        _ ->
            Cmd.none


subscriptions model =
    Sub.batch
        [ setUserBalance SetUserBalance
        , setUserCoins SetUserCoins
        , triggerUpdate TriggerUpdate
        , Time.every (1 * second) Tick
        ]
