module Game exposing (Game, getGame, Player, Players)
import Array exposing (Array)

type alias Player = {complete: Int, blocked: Int}

type alias Players = { one: Player, two: Player }

type alias Game = { board: Array Int, players: Players, dice: List Int, activePlayer: String}

getGame : a -> Game
getGame a =
  {
    board = Array.fromList [2, 0, 0, 0, 0, -5, 0, -3, 0, 0, 0, 5, -5, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, -2],
    players = {one = {complete = 0, blocked = 0}, two = {complete = 0, blocked = 0}},
    activePlayer = "one",
    dice = [ 1 , 5 ]
  }
