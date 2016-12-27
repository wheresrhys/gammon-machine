module Board exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Array exposing (Array)
import Slot

-- MODEL
type alias Model =
  {
    slots : Array Slot.Model,
    activeSlot : Int
  }

initialModel : Model
initialModel =
  (
    [2, 0, 0, 0, 0, -5, 0, -3, 0, 0, 0, 5, -5, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, -2]
    |> Array.fromList
    |> Array.indexedMap (,)
    |> Array.map Slot.fromInteger
    |> Model
  )
  -1

-- UPDATE
type Msg
  = SlotClick Int

--getSlot: Int -> Slot.Model
--getSlot pos =
--  let maybeSlot = Array.get pos
--  in
--  case maybeSlot of
--    Just slot ->
--      slot
--    Nothing ->
--      Debug.crash (toString "pos") ++ " is not a valid backgammon board slot"

modifySlot pos slots =
  Array.set pos (
    slots
    |> Array.get pos
    |> Maybe.withDefault (Slot.fromInteger (0, -1))
    |> (\slot -> {slot | isActive = True})
  ) slots

update : Msg -> Model -> Model
update msg model =
  case msg of
    SlotClick pos ->
      if (model.activeSlot == pos && (model.slots |> Array.get pos |> Maybe.map (\slot -> if slot.counters > 0 then True else False) |> Maybe.withDefault False))
      then
        { model |
          activeSlot = -1,
          slots = model.slots |> Array.indexedMap (\i slot -> {slot | isActive = False}) }
      else
        { model |
          activeSlot = pos,
          slots = model.slots |> Array.indexedMap (\i slot -> if i == pos then {slot | isActive = True} else {slot | isActive = False}) }

-- VIEW
view : Model -> Html Msg
view model =
  model.slots |> Array.map (Slot.view SlotClick) |> Array.toList |> ol []


