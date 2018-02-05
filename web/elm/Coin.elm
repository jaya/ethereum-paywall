port module Coin exposing (..)


port getUserBalance : String -> Cmd msg


port setUserBalance : (Float -> msg) -> Sub msg
