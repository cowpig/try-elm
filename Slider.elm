module Slider exposing (..)

import Html exposing (Html, div, Attribute)
import Html.Attributes exposing (style)
import Html.App as App
import Html.Events exposing (onMouseDown)
import Mouse exposing (Position)
import Debug exposing (crash, log)

main =
    App.program 
        { 
            init = init, 
            view = view, 
            update = update, 
            subscriptions = subscriptions
        }

-- Model
type alias Model =
    { 
        sliderTopLeft : Position,
        sliderBotRight : Position,
        sliderYPad : Int,
        selectorVal : Int,
        selectorWidth : Int,
        drag : Maybe Drag
    }

type alias Drag =
    {
        start : Maybe Position,
        end : Maybe Position
    }

init: ( Model, Cmd Msg )
init = let _ = log "INIT" in ( {
            sliderTopLeft = (Position 100 100),
            sliderBotRight = (Position 400 150),
            sliderYPad = 3,
            selectorVal = 50,
            selectorWidth = 9,
            drag = Nothing
        }, 
        Cmd.none )


-- Messages
type Msg = DragStart | DragTo Position | DragEnd Position


-- Updates
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        DragStart ->
            ({model | drag = Just { start = Nothing, end = Nothing } }, Cmd.none)
        DragTo position ->
            case model.drag of
                Nothing ->
                    (model, Cmd.none)
                Just {start, end} ->
                    case start of
                        Nothing ->
                            let
                                drag = Just {
                                    start = Just position,
                                    end = Just position
                                }
                            in
                                ({ model | 
                                    drag = drag, 
                                    selectorVal = sliderValFromMousePos model position 
                                }, Cmd.none)
                        Just _ ->
                            let
                                drag = Just {
                                    start = start,
                                    end = Just position
                                }
                            in
                                ({ model | 
                                    drag = drag, 
                                    selectorVal = sliderValFromMousePos model position 
                                }, Cmd.none)
                    
        DragEnd position ->
            ({model | drag = Nothing}, Cmd.none)


sliderValFromMousePos : Model -> Position -> Int
sliderValFromMousePos model position =
    let _ = log "sliderValFromMousePos" (model, position) in
    if position.x < model.sliderTopLeft.x then
        0
    else if position.x > model.sliderBotRight.x then
        100
    else
        let
            width = model.sliderBotRight.x - model.sliderTopLeft.x
            dist = position.x - model.sliderTopLeft.x
        in
            let 
                _ = log "dist, width" (dist, width) 
                output = round ( (toFloat dist) / (toFloat width) * 100 )
                _ = log "output" output
            in
                output


-- View
view : Model -> Html Msg
view model =
    div [wrapperStyle model] [
        div [sliderStyle model] [],
        div [selectorStyle model, onMouseDown DragStart ] []
    ]

sliderHeight : Model -> Int
sliderHeight model = model.sliderBotRight.y - model.sliderTopLeft.y

sliderWidth : Model -> Int
sliderWidth model = model.sliderBotRight.x - model.sliderTopLeft.x

wrapperStyle : Model -> Attribute msg
wrapperStyle model =
    style [
            ("position", "absolute"),
            ("top", px model.sliderTopLeft.y),
            ("left", px model.sliderTopLeft.x),
            ("height", px (model.sliderBotRight.y - model.sliderTopLeft.y)),
            ("width", px (model.sliderBotRight.x - model.sliderTopLeft.x))
    ]

selectorStyle : Model -> Attribute msg
selectorStyle model =
    let
        midX = round (
                toFloat (sliderWidth model) * 
                (toFloat model.selectorVal / 100)
            )
        left = midX - round (toFloat model.selectorWidth / 2)
    in
        style [
            ("position", "absolute"),
            ("top", px 0),
            ("left", px left),
            ("height", px (sliderHeight model)),
            ("width", px model.selectorWidth),
            ("background-color", "black")
        ]

sliderStyle : Model -> Attribute msg
sliderStyle model =
    style [
        ("position", "absolute"),
        ("top", px model.sliderYPad),
        ("left", px 0),
        ("height", px (sliderHeight model - (2 * model.sliderYPad))),
        ("width", px (sliderWidth model)),
        ("background-color", "red")
    ]

px : Int -> String
px int = toString int ++ "px"

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  case model.drag of
    Nothing ->
      Sub.none

    Just _ ->
      Sub.batch [ Mouse.moves DragTo, Mouse.ups DragEnd ]
