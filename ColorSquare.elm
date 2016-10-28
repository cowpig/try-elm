module ColorSquare exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Html.App

import Color
import Color.Convert

import Random


-- Model

type alias Model = {
    color : Color.Color,
    seed : Random.Seed
}

init : ( Model, Cmd Msg )
init = 
    ( 
        {color = Color.rgb 0 255 0, seed = Random.initialSeed 1234 },  
        Cmd.none
    )


-- Messages

type Msg = ChangeColor


-- View

view : Model -> Html Msg

view model =
        div 
        [ 
            ( onClick ChangeColor ) , 
            ( style [
                    ( 
                        "background-color", 
                        Color.Convert.colorToCssRgb model.color 
                    ),
                    ( "height", "200px" ),
                    ( "width", "500px" )
                ]
            )
        ]
        []

-- Update

randomColor : Random.Generator Color.Color
randomColor =
  Random.map3 Color.rgb (Random.int 0 255) (Random.int 0 255) (Random.int 0 255)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of
        ChangeColor ->
            let
                (color, seed) = Random.step randomColor model.seed
            in
                ({color = color, seed = seed} , Cmd.none )


-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- Main

main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
