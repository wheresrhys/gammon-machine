module Slot exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Array exposing (Array)

-- MODEL

type alias White = String
type alias Black = String

type Color = Black | White

type alias Model = { color: Color, position: Int, counters: Int, isActive: Bool}

fromInteger : (Int, Int) -> Model
fromInteger tuple =
  let
    index = Tuple.first tuple
    counters = Tuple.second tuple
  in
  if counters > 0
  then
    Model White index counters False
  else
    Model Black index -counters False

-- VIEW

colorStyle: Color -> Bool -> Attribute a
colorStyle color isActive =
  case color of
    White ->
      style [("background", "white"),("color","black"),("border-color", if isActive == True then "red" else "blue")]
    Black ->
      style [("background", "black"),("color","white"),("border-color", if isActive == True then "red" else "blue")]

counters: (Int -> a) -> Model -> List (Html a)
counters handler slot =
  if slot.counters > 0
  then
    [ button [colorStyle slot.color slot.isActive, onClick (handler slot.position)] (Array.toList ( Array.initialize slot.counters (\n -> span [] [text "str "]) ) )]
  else
    [ button [onClick (handler slot.position)] [text "empty column"]]

view : (Int -> a) -> Model -> Html a
view handler slot =
  li [] (counters handler slot)
