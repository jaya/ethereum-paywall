port module Coin exposing (..)

import PurchaseInfo exposing (PurchaseInfo)


port getUserBalance : String -> Cmd msg


port setUserBalance : (Float -> msg) -> Sub msg


port purchaseCoins : PurchaseInfo -> Cmd msg


port getUserCoins : String -> Cmd msg


port setUserCoins : (Float -> msg) -> Sub msg
