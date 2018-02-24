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
filterPokemonOfType selectedPokemonType pokemon =
    case selectedPokemonType of
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
