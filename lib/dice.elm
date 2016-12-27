module Dice exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Random


-- MODEL
type alias Model =
  { faces : List Int
  }


initialModel : Model
initialModel =
  Model []

-- UPDATE
type Msg
  = Roll
  | NewFace (Int, Int)
  | Used Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.pair (Random.int 1 6) (Random.int 1 6)))

    NewFace newFace ->
      if (Tuple.first newFace == Tuple.second newFace)
      then
        (Model [Tuple.first newFace, Tuple.first newFace, Tuple.first newFace, Tuple.first newFace], Cmd.none)
      else
        (Model [Tuple.first newFace, Tuple.second newFace], Cmd.none)
    Used face ->
      (Model [face], Cmd.none)


-- VIEW
face : Int -> Html Msg
face int =
  button [ onClick (Used int)] [ int |> toString |> text ]

view : Model -> Html Msg
view model =
  div []
    [
      h1 [] (List.map face model.faces),
      button [ onClick Roll ] [ text "Roll" ]
    ]