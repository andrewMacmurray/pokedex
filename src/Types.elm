module Types exposing (..)

import Dict exposing (Dict)
import Http
import Json.Decode exposing (Value)


type alias Model =
    { pokedex : Pokedex
    , selectedPokemon : Maybe Int
    , selectedType : Maybe PokemonType
    , imageOption : ImageOption
    }


type alias Pokedex =
    Dict Int Pokemon


type alias Pokemon =
    { id : Int
    , name : String
    , img : String
    , sprite : String
    , spriteAnimated : String
    , pokemonType : List PokemonType
    , weaknesses : List PokemonType
    , height : String
    , weight : String
    }


type ImageOption
    = ThreeD
    | Sprite
    | Animated


type PokemonType
    = Grass
    | Water
    | Fire
    | Normal
    | Fighting
    | Flying
    | Poison
    | Electric
    | Ground
    | Psychic
    | Rock
    | Ice
    | Bug
    | Dragon
    | Ghost
    | Dark
    | Steel
    | Fairy


type Msg
    = CheckCache
    | CacheResponse Value
    | ClearCache
    | ReceivePokedex (Result Http.Error Pokedex)
    | SelectPokemon Int
    | ClearSelectedPokemon
    | ToggleSelectedType PokemonType
    | SetImageOption ImageOption
