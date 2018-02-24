module State exposing (..)

import Dict
import Json.Decode exposing (Value, decodeValue)
import Data.Port exposing (cacheResponse, checkCache, clearCache, populateCache)
import Request.Pokedex exposing (encodePokedex, getPokedex, pokedexDecoder)
import Types exposing (..)


-- Init


init : ( Model, Cmd Msg )
init =
    initialModel ! [ checkCache ]


initialModel : Model
initialModel =
    { pokedex = Dict.empty
    , selectedPokemon = Nothing
    , selectedType = Nothing
    , imageOption = Sprite
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceivePokedex (Err _) ->
            model ! []

        ReceivePokedex (Ok pokedex) ->
            { model | pokedex = pokedex } ! [ populateCache <| encodePokedex pokedex ]

        CheckCache ->
            model ! [ checkCache ]

        CacheResponse val ->
            handleCacheResponse val model

        ClearCache ->
            model ! [ clearCache ]

        SelectPokemon n ->
            { model | selectedPokemon = Just n } ! []

        ClearSelectedPokemon ->
            { model | selectedPokemon = Nothing } ! []

        ToggleSelectedType pokemonType ->
            handleToggleSelectedType pokemonType model ! []

        SetImageOption imageOption ->
            { model | imageOption = imageOption } ! []



-- Update Helpers


handleCacheResponse : Value -> Model -> ( Model, Cmd Msg )
handleCacheResponse cacheValue model =
    case decodeValue pokedexDecoder cacheValue of
        Err err ->
            model ! [ getPokedex ]

        Ok pokedex ->
            { model | pokedex = pokedex } ! []


handleToggleSelectedType : PokemonType -> Model -> Model
handleToggleSelectedType pokemonType model =
    if model.selectedType == Just pokemonType then
        { model | selectedType = Nothing }
    else
        { model | selectedType = Just pokemonType }



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    cacheResponse CacheResponse
