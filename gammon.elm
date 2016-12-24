import Html exposing (..)
import Html.Events exposing (onClick)
import Array exposing (Array)

main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
model : Array Int
model =
  Array.fromList [0, 2, 0, 0, 0, 0, -5, 0, -3, 0, 0, 0, 5, -5, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, -2, 0]

-- UPDATE

type alias Msg = Int

update : Msg -> Array Int -> Array Int
update msg model =
  model

-- VIEW

toBoard : Array Int -> Html msg
toBoard list =
  div []
    [
      div [] [
        text ("player1 " ++ (toString (Array.get 0 list)))
      ],
      toHtmlList list,
      div [] [
        text ("player2 " ++ (toString (Array.get ((Array.length list) - 1) list)))
      ]
    ]

toHtmlList : Array Int -> Html msg
toHtmlList list =
  ol [] (Array.toList (Array.indexedMap toLi (Array.slice 1 ((Array.length list) - 1) list)))

toLi : Int -> Int -> Html msg
toLi s i =
  li [] [
    button [] [text ( toString s ++ toString i )]
  ]

view : Array Int -> Html Msg
view model =
  toBoard model


--ol [] (List.indexedMap toLi (List.tail (List.take (strings.length - 1) strings)))


---- VIEW


--view : Model -> Html Msg
--view model =
--  div []
--    [ button [ onClick Decrement ] [ text "-" ]
--    , div [] [ text (toString model) ]
--    , button [ onClick Increment ] [ text "+" ]
--    ]

