module View exposing (..)

import Data.Pokedex exposing (..)
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types exposing (..)


-- View


view : Model -> Html Msg
view model =
    div [ class "pa3 pb5 center mw8" ]
        [ h1 [ class "tc" ] [ text "Pokédex" ]
        , renderDetail model
        , div [ class "flex flex-wrap justify-center pb4" ] <| List.map (pokemonTypeOption model) selectablePokemonTypes
        , div [ class "flex flex-wrap" ] <| renderPokedex model
        , p [ onClick ClearCache, class "mt5 ml3 red pointer" ] [ text "reset cache" ]
        ]


pokemonTypeOption : Model -> PokemonType -> Html Msg
pokemonTypeOption model pokemonType =
    let
        isSelected =
            model.selectedType == Just pokemonType
    in
        div
            [ classes
                [ "ph3 pv3 br-pill tc"
                , "dib f6 pointer ma2 ba2 hover-white text-animate"
                , "noselect"
                , "bg-" ++ pokemonTypeColor pokemonType
                ]
            , classList
                [ ( "white ba2 b--black", isSelected )
                , ( "b--white", not isSelected )
                ]
            , style [ width 90 ]
            , onClick <| ToggleSelectedType pokemonType
            ]
            [ h5 [ class "ma0" ] [ text <| toString pokemonType ] ]


pokemonTypeDetail : PokemonType -> Html msg
pokemonTypeDetail pokemonType =
    div
        [ classes
            [ "ph3 pv3 br-pill tc"
            , "dib f6 pointer ma2 ba2"
            , "noselect"
            , "bg-" ++ pokemonTypeColor pokemonType
            ]
        , style [ width 90 ]
        ]
        [ h5 [ class "ma0" ] [ text <| toString pokemonType ] ]


renderDetail : Model -> Html Msg
renderDetail model =
    model.selectedPokemon
        |> Maybe.andThen (\n -> Dict.get n model.pokedex)
        |> Maybe.map pokemonDetail
        |> Maybe.withDefault (span [] [])


pokemonDetail : Pokemon -> Html Msg
pokemonDetail ({ pokemonType, img } as pokemon) =
    div
        [ classes
            [ "w-100 h-100 fixed z-2 top-0 left-0 pointer"
            , "flex flex-column justify-center"
            , "pa4 tc"
            , "bg-" ++ primaryPokemonColor pokemonType
            , primaryPokemonTextColor pokemonType
            , "overflow-scroll"
            ]
        , onClick ClearSelectedPokemon
        ]
        [ h1
            [ class "absolute top-1 right-1 ma0 pa3 pointer"
            , onClick ClearSelectedPokemon
            ]
            [ text "X" ]
        , div
            [ style [ backgroundImage img, height 200 ]
            , class "w-50 center bg-center contain"
            ]
            []
        , div [] <| List.map pokemonTypeDetail pokemonType
        , h1 [] [ text pokemon.name ]
        , p [] [ text pokemon.weight ]
        , p [] [ text pokemon.height ]
        ]


renderPokemonType : PokemonType -> Html Msg
renderPokemonType pokemonType =
    div
        [ classes
            [ "bg-" ++ pokemonTypeColor pokemonType
            , "br-100 dib ba b--white mh1"
            ]
        , style [ width 15, height 15 ]
        ]
        []


renderPokedex : Model -> List (Html Msg)
renderPokedex model =
    model.pokedex
        |> pokedexToList
        |> filterPokemonOfType model.selectedType
        |> List.map renderPokemon


renderPokemon : Pokemon -> Html Msg
renderPokemon { pokemonType, id, img, name } =
    div [ class "pa1 w-20-ns w-50 dib tc pointer" ]
        [ div
            [ classes
                [ "pa4-ns pa2 bg-animate relative"
                , "text-animate"
                , "hover-" ++ primaryPokemonTextHover pokemonType
                , "bg-" ++ primaryPokemonColor pokemonType
                , primaryPokemonTextColor pokemonType
                ]
            , onClick <| SelectPokemon id
            ]
            [ p [ class "f7" ] [ text <| toString id ]
            , div [ class "absolute top-1 right-1" ] <| List.map renderPokemonType pokemonType
            , div
                [ style [ backgroundImage img, height 100 ]
                , class "w-100 bg-center contain"
                ]
                []
            , p [] [ text name ]
            ]
        ]



-- View Helpers


primaryPokemonTextHover : List PokemonType -> String
primaryPokemonTextHover =
    typeColorFromList complementaryTextHover


primaryPokemonTextColor : List PokemonType -> String
primaryPokemonTextColor =
    typeColorFromList complementaryTextColor


complementaryTextHover : PokemonType -> String
complementaryTextHover pokemonType =
    case pokemonType of
        Water ->
            "dark-gray"

        Grass ->
            "dark-gray"

        Poison ->
            "black"

        Psychic ->
            "dark-gray"

        Fighting ->
            "dark-gray"

        Normal ->
            "pink"

        Rock ->
            "black"

        Ghost ->
            "black"

        Dragon ->
            "blue"

        _ ->
            "white"


complementaryTextColor : PokemonType -> String
complementaryTextColor pokemonType =
    case pokemonType of
        Fire ->
            "dark-gray"

        Normal ->
            "gray"

        Electric ->
            "dark-gray"

        Ground ->
            "dark-gray"

        Bug ->
            "dark-green"

        Ice ->
            "dark-blue"

        _ ->
            "white"


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


primaryPokemonColor : List PokemonType -> String
primaryPokemonColor =
    typeColorFromList pokemonTypeColor


typeColorFromList : (PokemonType -> String) -> List PokemonType -> String
typeColorFromList f pokemonTypes =
    pokemonTypes
        |> List.head
        |> Maybe.map f
        |> Maybe.withDefault ""


classes : List String -> Attribute msg
classes =
    String.join " " >> class


backgroundImage : String -> ( String, String )
backgroundImage url =
    ( "background-image", "url(" ++ url ++ ")" )


width : number -> ( String, String )
width px =
    ( "width", toString px ++ "px" )


height : number -> ( String, String )
height px =
    ( "height", toString px ++ "px" )
