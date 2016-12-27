import Html exposing (..)
import Dice

-- MODEL
type alias AppModel =
  {
    diceModel : Dice.Model
  }

initialModel : AppModel
initialModel =
  {
    diceModel = Dice.initialModel
  }

init : ( AppModel, Cmd Msg )
init =
    ( initialModel, Cmd.none )

-- UPDATE
type Msg
    = DiceMsg Dice.Msg

update : Msg -> AppModel -> (AppModel, Cmd Msg)
update msg model =
  case msg of
    DiceMsg subMsg ->
      let
        ( updatedDiceModel, diceCmd ) =
          Dice.update subMsg model.diceModel
      in
        ( { model | diceModel = updatedDiceModel }, Cmd.map DiceMsg diceCmd )

-- VIEW
view : AppModel -> Html Msg
view model =
  div []
    [
      h1 [] [text "A backgammon game yo"],
      Html.map DiceMsg (Dice.view model.diceModel)
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