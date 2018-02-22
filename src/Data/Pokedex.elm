module Data.Pokedex exposing (..)

import Dict
import Types exposing (..)


pokedexToList : Pokedex -> List Pokemon
pokedexToList pokedex =
    pokedex
        |> Dict.toList
        |> List.map Tuple.second


makePokedex : List Pokemon -> Pokedex
makePokedex pokemon =
    pokemon
        |> List.map (\p -> ( p.id, p ))
        |> Dict.fromList


filterPokemonOfType : Maybe PokemonType -> List Pokemon -> List Pokemon
filterPokemonOfType pokemonType pokemon =
    case pokemonType of
        Just pkt ->
            pokemon |> List.filter (\p -> List.member pkt p.pokemonType)

        Nothing ->
            pokemon


selectablePokemonTypes : List PokemonType
selectablePokemonTypes =
    [ Grass
    , Water
    , Fire
    , Normal
    , Fighting
    , Flying
    , Poison
    , Electric
    , Ground
    , Psychic
    , Rock
    , Ice
    , Bug
    , Dragon
    , Ghost
    ]


pokemonTypeColor : PokemonType -> String
pokemonTypeColor pokemonType =
    case pokemonType of
        Grass ->
            "green"

        Water ->
            "blue"

        Fire ->
            "gold"

        Normal ->
            "light-gray"

        Fighting ->
            "orange"

        Flying ->
            "light-yellow"

        Poison ->
            "purple"

        Electric ->
            "yellow"

        Ground ->
            "moon-gray"

        Psychic ->
            "dark-pink"

        Rock ->
            "light-silver"

        Ice ->
            "lightest-blue"

        Bug ->
            "light-green"

        Dragon ->
            "dark-blue"

        Ghost ->
            "light-purple"

        Dark ->
            "navy"

        Steel ->
            "moon-gray"

        Fairy ->
            "washed-red"
