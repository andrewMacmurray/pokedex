module Request.Pokedex exposing (..)

import Data.Pokedex exposing (makePokedex, pokedexToList)
import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Json.Encode as Encode
import Types exposing (..)


getPokedex : Cmd Msg
getPokedex =
    Http.get pokedexUrl (field "pokemon" pokedexDecoder) |> Http.send ReceivePokedex


pokedexUrl : String
pokedexUrl =
    "https://api.myjson.com/bins/i4pil"


pokedexDecoder : Decoder Pokedex
pokedexDecoder =
    Decode.map makePokedex <| list pokemonDecoder


pokemonDecoder : Decoder Pokemon
pokemonDecoder =
    decode Pokemon
        |> required "id" int
        |> required "name" string
        |> required "img" string
        |> required "sprite" string
        |> required "spriteAnimated" string
        |> custom pokemonTypeDecoder
        |> optional "weaknesses" pokemonTypes []
        |> required "height" string
        |> required "weight" string


pokemonTypeDecoder : Decoder (List PokemonType)
pokemonTypeDecoder =
    oneOf
        [ field "type" pokemonTypes
        , field "pokemonType" pokemonTypes
        ]


pokemonTypes : Decoder (List PokemonType)
pokemonTypes =
    list <| Decode.andThen toPokemonType string


encodePokedex : Pokedex -> List Encode.Value
encodePokedex pokedex =
    pokedex
        |> pokedexToList
        |> List.map encodePokemon


encodePokemon : Pokemon -> Encode.Value
encodePokemon pokemon =
    Encode.object
        [ ( "id", Encode.int pokemon.id )
        , ( "name", Encode.string pokemon.name )
        , ( "img", Encode.string pokemon.img )
        , ( "sprite", Encode.string pokemon.sprite )
        , ( "spriteAnimated", Encode.string pokemon.spriteAnimated )
        , ( "pokemonType", Encode.list <| List.map fromPokemonType pokemon.pokemonType )
        , ( "weaknesses", Encode.list <| List.map fromPokemonType pokemon.weaknesses )
        , ( "height", Encode.string pokemon.height )
        , ( "weight", Encode.string pokemon.weight )
        ]


fromPokemonType : PokemonType -> Encode.Value
fromPokemonType pokemonType =
    case pokemonType of
        Grass ->
            Encode.string "Grass"

        Water ->
            Encode.string "Water"

        Fire ->
            Encode.string "Fire"

        Normal ->
            Encode.string "Normal"

        Fighting ->
            Encode.string "Fighting"

        Flying ->
            Encode.string "Flying"

        Poison ->
            Encode.string "Poison"

        Electric ->
            Encode.string "Electric"

        Ground ->
            Encode.string "Ground"

        Psychic ->
            Encode.string "Psychic"

        Rock ->
            Encode.string "Rock"

        Ice ->
            Encode.string "Ice"

        Bug ->
            Encode.string "Bug"

        Dragon ->
            Encode.string "Dragon"

        Ghost ->
            Encode.string "Ghost"

        Dark ->
            Encode.string "Dark"

        Steel ->
            Encode.string "Steel"

        Fairy ->
            Encode.string "Fairy"


toPokemonType : String -> Decoder PokemonType
toPokemonType s =
    case s of
        "Grass" ->
            Decode.succeed Grass

        "Water" ->
            Decode.succeed Water

        "Fire" ->
            Decode.succeed Fire

        "Normal" ->
            Decode.succeed Normal

        "Fighting" ->
            Decode.succeed Fighting

        "Flying" ->
            Decode.succeed Flying

        "Poison" ->
            Decode.succeed Poison

        "Electric" ->
            Decode.succeed Electric

        "Ground" ->
            Decode.succeed Ground

        "Psychic" ->
            Decode.succeed Psychic

        "Rock" ->
            Decode.succeed Rock

        "Ice" ->
            Decode.succeed Ice

        "Bug" ->
            Decode.succeed Bug

        "Dragon" ->
            Decode.succeed Dragon

        "Ghost" ->
            Decode.succeed Ghost

        "Dark" ->
            Decode.succeed Dark

        "Steel" ->
            Decode.succeed Steel

        "Fairy" ->
            Decode.succeed Fairy

        _ ->
            Decode.fail "unrecognized pokemon type"
