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
        , renderSelectedPokemonDetail model
        , div [ class "flex flex-wrap justify-center pb4" ] <| List.map (pokemonTypeOption model) selectablePokemonTypes
        , imageOptions model
        , div [ class "flex flex-wrap" ] <| renderPokedex model
        , p [ onClick ClearCache, class "mt5 ml3 red pointer" ] [ text "reset cache" ]
        ]


imageOptions : Model -> Html Msg
imageOptions model =
    div [] <| List.map (imageOption model) [ Sprite, Animated, ThreeD ]


imageOption : Model -> ImageOption -> Html Msg
imageOption model opt =
    div
        [ onClick <| SetImageOption opt
        , class "pointer f6 ttu dib ml1 hover-red text-animate"
        , classList [ ( "red", opt == model.imageOption ) ]
        ]
        [ p [ class "mr4" ] [ text <| imageOptionToString opt ] ]


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


renderSelectedPokemonDetail : Model -> Html Msg
renderSelectedPokemonDetail model =
    model.selectedPokemon
        |> Maybe.andThen (\n -> Dict.get n model.pokedex)
        |> Maybe.map (renderPokemonDetail model)
        |> Maybe.withDefault (span [] [])


renderPokemonDetail : Model -> Pokemon -> Html Msg
renderPokemonDetail model ({ pokemonType, img, sprite, spriteAnimated } as pokemon) =
    div [ class "fixed w-100 h-100 z-2 top-0 left-0 pointer white" ]
        [ div
            [ classes
                [ "w-100 h-100 flex flex-column justify-center"
                , "tc pa4"
                , "bg-" ++ primaryPokemonColor pokemonType
                , primaryPokemonTextColor pokemonType
                , "overflow-scroll"
                ]
            , onClick ClearSelectedPokemon
            ]
            [ div [ class "flex items-center", style [ height 200 ] ]
                [ div
                    [ style <| imageOptionDetailStyles model.imageOption pokemon
                    , class "w-33 center bg-center contain"
                    ]
                    []
                ]
            , div [] <| List.map pokemonTypeDetail pokemonType
            , h1 [] [ text pokemon.name ]
            , p [] [ text pokemon.weight ]
            , p [] [ text pokemon.height ]
            ]
        , p
            [ class "f2 absolute z-5 top-1 right-1 ma0 ph3 pb3 pt2 pointer"
            , onClick ClearSelectedPokemon
            ]
            [ text "X" ]
        , div [ class "absolute top-1 left-1 z-5" ] [ imageOptions model ]
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
        |> List.map (renderPokemon model.imageOption)


renderPokemon : ImageOption -> Pokemon -> Html Msg
renderPokemon opt ({ pokemonType, id, name } as pokemon) =
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
            , div [ class "flex items-center", style [ height 100 ] ]
                [ div
                    [ style <| imageOptionStyles opt pokemon
                    , class "w-100 bg-center contain"
                    ]
                    []
                ]
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


imageOptionDetailStyles : ImageOption -> Pokemon -> List ( String, String )
imageOptionDetailStyles imageOption pokemon =
    let
        url =
            imageOptionUrl imageOption pokemon
    in
        case imageOption of
            ThreeD ->
                [ backgroundImage url, height 200 ]

            Animated ->
                [ backgroundImage url, height 150 ]

            Sprite ->
                [ backgroundImage url, height 200 ]


imageOptionStyles : ImageOption -> Pokemon -> List ( String, String )
imageOptionStyles imageOption pokemon =
    let
        url =
            imageOptionUrl imageOption pokemon
    in
        case imageOption of
            ThreeD ->
                [ backgroundImage url, height 100 ]

            Animated ->
                [ backgroundImage url, height 70 ]

            Sprite ->
                [ backgroundImage url, height 100 ]


imageOptionUrl : ImageOption -> Pokemon -> String
imageOptionUrl imageOption pokemon =
    case imageOption of
        ThreeD ->
            pokemon.img

        Animated ->
            pokemon.spriteAnimated

        Sprite ->
            pokemon.sprite


imageOptionToString : ImageOption -> String
imageOptionToString imageOption =
    case imageOption of
        ThreeD ->
            "3D"

        Animated ->
            "Animated"

        Sprite ->
            "Sprite"


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
