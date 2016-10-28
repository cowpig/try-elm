import Html exposing (Html, div)
import Html.App as App
import Mouse exposing (Position)

main =
    Html.App.program 
        { 
            init = init, 
            view = view, 
            update = update, 
            subscriptions = subscriptions
        }

-- Model
type alias Model =
    { 
        sliderPos : Int, 
        drag : Maybe Drag
    }

type alias Drag =
    { 
        start : Position,
        current : Position
    }

init: ( Model, Cmd Msg )
init = ( Model 49 Nothing, Cmd.none )

-- Messages
type Msg = DragStart Position | DragAt Position | DragEnd Position

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  case model.drag of
    Nothing ->
      Sub.none

    Just _ ->
      Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]
