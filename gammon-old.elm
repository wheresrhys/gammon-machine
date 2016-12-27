import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Array exposing (Array)
import Game
import Slot
import Dice

main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
model : Game.Game
model =
  Game.getGame Slot.White

-- UPDATE

type Msg = Roll | NewFace Int

update : Msg -> Game.Game -> Game.Game
update msg model =
  model

-- VIEW


toLeaderboard: Game.Players -> Html msg
toLeaderboard players =
  ol [] [
    toPlayer players.white Slot.White,
    toPlayer players.black Slot.Black
  ]

toPlayer: Game.Player -> Slot.Color -> Html msg
toPlayer p color=
  li [(Slot.colorStyle color)] [ text ((toString p.complete) ++ (toString p.blocked))]

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
