module Main exposing (..)

import Html exposing (beginnerProgram, div, button, h1, h4, text)
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


type Msg
    = Increment


type alias Model =
    { counter : Int, txt : String }


model : Model
model =
    { counter = 0, txt = "Hello, World...from Elm!" }


update : Msg -> Model -> Model
update m model =
    { model | counter = model.counter + 1 }


view : Model -> Html.Html Msg
view model =
    div []
        [ h1 [] [ text model.txt ]
        , h4 [] [ text (toString model.counter) ]
        , button [ onClick Increment ] [ text "Click Me" ]
        ]
