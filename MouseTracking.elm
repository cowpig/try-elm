module MouseTracking exposing (..)

import Html exposing (Html, text, div)
import Html.App
import Mouse

main =
    Html.App.program 
        { 
            init = init, 
            view = view, 
            update = update, 
            subscriptions = subscriptions
        }


-- Model
type alias Model = {
    x : Int,
    y : Int,
    mousedown : Bool
}

init : ( Model, Cmd Msg )
init = ( { x = 0, y = 0, mousedown = False }, Cmd.none )


-- Messages
type Msg = MoveMsg Mouse.Position |
    UpMsg Mouse.Position | 
    DownMsg Mouse.Position


-- View
view : Model -> Html Msg
view model =
    div []
        [ text (stringify model) ]


-- Update
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MoveMsg position ->
            ( {model | x = position.x, y = position.y}, Cmd.none )
        UpMsg position ->
            ( {x = position.x, y = position.y, mousedown = False}, Cmd.none )
        DownMsg position ->
            ( {x = position.x, y = position.y, mousedown = True}, Cmd.none )

stringify : Model -> String
stringify model =
    if model.mousedown then
        toString model.x ++ ", " ++ toString model.y ++ " click!"
    else
        toString model.x ++ ", " ++ toString model.y


-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [
        Mouse.moves MoveMsg,
        Mouse.ups UpMsg,
        Mouse.downs DownMsg
    ]
