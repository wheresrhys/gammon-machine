module Slot exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Array exposing (Array)

-- MODEL

type alias White = String
type alias Black = String

type Color = Black | White

type alias Slot = { color: Color, number: Int, active: Bool}

fromInteger : Int -> Slot
fromInteger i =
  if i > 0
  then
    Slot White i False
  else
    Slot Black -i False

-- UPDATE

type Msg = Roll | NewFace Int

update : Msg -> Slot -> Slot
update msg model =
  model

-- VIEW

toLi : Color -> Int -> Html msg
toLi color s =
  li [] (counters color s)

colorStyle: Color -> Attribute msg
colorStyle color =
  case color of
    White ->
      style [("background", "white"),("color","black")]
    Black ->
      style [("background", "black"),("color","white")]

counters: Color -> Int -> List (Html msg)
counters color i =
  if i > 0
  then
    [ button [colorStyle color] (Array.toList ( Array.initialize (abs i) (\n -> span [] [text "str "]) ) )]
  else
    [ button [] [text "empty column"]]

view : Slot -> Html msg
view slot =
  toLi slot.color slot.number
