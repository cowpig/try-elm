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
    y : Int
}
 
init : ( Model, Cmd Msg )
init = ( { x = 0, y = 0 }, Cmd.none )

-- Messages
type Msg = 
    MoveMsg Mouse.Position
    --UpMsg Mouse.Position | 
    --DownMsg Mouse.Position


-- Handler
mouseMsgHandler : Mouse.Position -> Msg
mouseMsgHandler position =
    MoveMsg position


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
            ( {x = position.x, y = position.y}, Cmd.none )

stringify : Mouse.Position -> String
stringify pos =
    toString pos.x ++ ", " ++ toString pos.y


-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [
        Mouse.moves mouseMsgHandler
        --Mouse.ups UpMsg,
        --Mouse.downs DownMsg
    ]
