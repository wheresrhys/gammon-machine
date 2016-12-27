import Html exposing (..)
import Dice
import Board

-- MODEL
type alias AppModel =
  {
    diceModel : Dice.Model,
    boardModel : Board.Model
  }

initialModel : AppModel
initialModel =
  {
    diceModel = Dice.initialModel,
    boardModel = Board.initialModel
  }

init : ( AppModel, Cmd Msg )
init =
    ( initialModel, Cmd.none )

-- UPDATE
type Msg
    = DiceMsg Dice.Msg
    | BoardMsg Board.Msg

update : Msg -> AppModel -> (AppModel, Cmd Msg)
update msg model =
  case msg of
    DiceMsg subMsg ->
      let
        ( updatedDiceModel, diceCmd ) =
          Dice.update subMsg model.diceModel
      in
        ( { model | diceModel = updatedDiceModel }, Cmd.map DiceMsg diceCmd )
    BoardMsg subMsg ->
      ( { model | boardModel = Board.update subMsg model.boardModel }, Cmd.none )

-- VIEW
view : AppModel -> Html Msg
view model =
  div []
    [
      h1 [] [text "A backgammon game yo"],
      Html.map DiceMsg (Dice.view model.diceModel),
      Html.map BoardMsg (Board.view model.boardModel)
    ]

-- SUBSCRIPTIONS
subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none

-- APP
main : Program Never AppModel Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }