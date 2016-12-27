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
  | DiceUsed (List Int)


removeItem : Maybe Int -> List Int -> List Int
removeItem maybeInt list =
  case maybeInt of
    Just int ->
      List.concat [
        list |> List.filter (\n -> n == int) |> (List.drop 1),
        list |> List.filter (\n -> n /= int)
      ]
    Nothing ->
      list

removeFaces : (List Int, List Int) -> (List Int, List Int)
removeFaces faces =
  let
    usedFaces = Tuple.first faces
    allFaces = Tuple.second faces
  in
    if (List.length usedFaces > 0)
    then
      (usedFaces |> List.drop 1 , allFaces |> removeItem (usedFaces |> List.head))
    else
      (usedFaces, allFaces)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.pair (Random.int 1 6) (Random.int 1 6)))

    NewFace newFace ->
      if (Tuple.first newFace == Tuple.second newFace)
      then
        let
          face = Tuple.first newFace
        in
          (Model [face, face, face, face], Cmd.none)
      else
        (Model [Tuple.first newFace, Tuple.second newFace], Cmd.none)
    DiceUsed faces ->
      ((faces, model.faces) |> removeFaces |> Tuple.second |> Model, Cmd.none)


-- VIEW
face : Int -> Html Msg
face int =
  button [ onClick (DiceUsed [int])] [ int |> toString |> text ]

view : Model -> Html Msg
view model =
  div []
    [
      h1 [] (List.map face model.faces),
      button [ onClick Roll ] [ text "Roll" ]
    ]