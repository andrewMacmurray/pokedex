port module Data.Port exposing (..)

import Json.Decode exposing (Value)


checkCache : Cmd msg
checkCache =
    checkCache_ ()


clearCache : Cmd msg
clearCache =
    clearCache_ ()


port checkCache_ : () -> Cmd msg


port cacheResponse : (Value -> msg) -> Sub msg


port clearCache_ : () -> Cmd msg


port populateCache : List Value -> Cmd msg
