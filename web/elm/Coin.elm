port module Coin exposing (..)

import PurchaseInfo exposing (PurchaseInfo)
import UserCoinInfo exposing (UserCoinInfo)


port getUserBalance : String -> Cmd msg


port setUserBalance : (Float -> msg) -> Sub msg


port purchaseCoins : PurchaseInfo -> Cmd msg


port getUserCoins : UserCoinInfo -> Cmd msg


port setUserCoins : (Maybe Float -> msg) -> Sub msg


port triggerUpdate : (() -> msg) -> Sub msg
