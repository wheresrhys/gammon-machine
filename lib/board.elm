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

moveIfValid : Model -> Int -> Model
moveIfValid model pos =
  { model |
    slots = model.slots
      |> modifySlot pos (\s -> {s | counters = 3, color = Slot.White})
      |> modifySlot model.activeSlot (\s -> {s | counters = 2, color = Slot.Black}),
    activeSlot = -1
  }

modifySlot : Int -> (Slot.Model -> Slot.Model) -> Array Slot.Model -> Array Slot.Model
modifySlot pos action slots=
  Array.set pos (
    slots
    |> Array.get pos
    |> Maybe.withDefault (Slot.fromInteger (0, -1))
    |> action
  ) slots

deactivateSlot : Model -> Model
deactivateSlot model =
  { model |
    activeSlot = -1,
    slots = model.slots |> Array.indexedMap (\i slot -> {slot | isActive = False}) }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SlotClick pos ->
      if (model.activeSlot == pos)
      then
        deactivateSlot model
      else
        -- if no active slot
        if (model.activeSlot == -1)
        then
          -- if activatable
          if (model.slots |> Array.get pos |> Maybe.map (\slot -> if slot.counters > 0 then True else False) |> Maybe.withDefault False)
          then
            { model |
              activeSlot = pos,
              slots = model.slots |> Array.indexedMap (\i slot -> if i == pos then {slot | isActive = True} else {slot | isActive = False}) }
          else
            model
        else
          -- try moving
          moveIfValid model pos

-- VIEW
view : Model -> Html Msg
view model =
  model.slots |> Array.map (Slot.view SlotClick) |> Array.toList |> ol []


