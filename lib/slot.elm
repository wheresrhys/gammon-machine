module Slot exposing (Slot, fromInteger, view)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Array exposing (Array)

-- MODEL

type alias Slot = { color: String, number: Int, active: Bool}

fromInteger : Int -> Slot
fromInteger i =
  if i > 0
  then
    Slot "white" i False
  else
    Slot "black" -i False

-- UPDATE

type Msg = Roll | NewFace Int

update : Msg -> Slot -> Slot
update msg model =
  model

-- VIEW

toLi : String -> Int -> Html msg
toLi color s =
  li [] (counters color s)

colorStyle: String -> Attribute msg
colorStyle color =
  if color == "white"
  then
    style [("background", "white"),("color","black")]
  else
    style [("background", "black"),("color","white")]

counters: String -> Int -> List (Html msg)
counters color i =
  if i > 0
  then
    [ button [colorStyle color] (Array.toList ( Array.initialize (abs i) (\n -> span [] [text "str "]) ) )]
  else
    [ button [] [text "empty column"]]

view : Slot -> Html msg
view slot =
  toLi slot.color slot.number
