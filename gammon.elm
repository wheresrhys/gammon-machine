import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Array exposing (Array)
import Game
import Slot

main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
model : Game.Game
model =
  Game.getGame "white"

-- UPDATE

type Msg = Roll | NewFace Int

update : Msg -> Game.Game -> Game.Game
update msg model =
  model

-- VIEW

toBoard : Array Slot.Slot -> Html msg
toBoard list =
  ol [] (Array.toList (Array.map Slot.view list))

toLi : Int -> Html msg
toLi s =
  li [] (counters s)

colour: Int -> Attribute msg
colour i =
  if i > 0
  then
    style [("background", "white"),("color","black")]
  else
    style [("background", "black"),("color","white")]

counters: Int -> List (Html msg)
counters i =
  if (abs i) > 0
  then
    [ button [colour i] (Array.toList ( Array.initialize (abs i) (\n -> span [] [text "str "]) ) )]
  else
    [ button [] [text "empty column"]]

toLeaderboard: Game.Players -> Html msg
toLeaderboard players =
  ol [] [
    toPlayer players.white 1,
    toPlayer players.black -1
  ]

toPlayer: Game.Player -> Int -> Html msg
toPlayer p sign=
  li [(colour sign)] [ text ((toString p.complete) ++ (toString p.blocked))]

toDiceDisplay : List Int -> Html msg
toDiceDisplay rolls =
  ul [] (List.map (\i -> li [] [text (toString i)]) rolls)

view : Game.Game -> Html msg
view model =
  div []
    [
      h1 [] [text "A backgammon game yo"],
      toLeaderboard model.players,
      toDiceDisplay model.dice,
      toBoard model.board
    ]
