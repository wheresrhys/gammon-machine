module Game exposing (Game, getGame, Player, Players)
import Array exposing (Array)
import Slot

type alias Player = {complete: Int, blocked: Int}

type alias Players = { white: Player, black: Player }

type alias Game = {
  board: Array Slot.Slot,
  players: Players,
  activePlayer: String,
  dice: List Int
}

getGame : String -> Game
getGame player =
  Game
    (Array.map Slot.fromInteger ([2, 0, 0, 0, 0, -5, 0, -3, 0, 0, 0, 5, -5, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, -2] |> Array.fromList))
    (Players (Player 0 0) (Player 0 0))
    player
    [ 1 , 5 ]
