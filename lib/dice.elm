import Html exposing (..)
import Html.Events exposing (..)
import Random

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { faces : List Int
  }


init : (Model, Cmd Msg)
init =
  (Model [1, 2], Cmd.none)



-- UPDATE


type Msg
  = Roll
  | NewFace (Int, Int)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.pair (Random.int 1 6) (Random.int 1 6)))

    NewFace newFace ->
      if (Tuple.first newFace == Tuple.second newFace)
      then
        (Model [Tuple.first newFace, Tuple.first newFace, Tuple.first newFace, Tuple.first newFace], Cmd.none)
      else
        (Model [Tuple.first newFace, Tuple.second newFace], Cmd.none)




-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] (List.map (text << toString) model.faces)
    , button [ onClick Roll ] [ text "Roll" ]
    ]