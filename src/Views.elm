module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Router


home : Html Msg
home =
    div [] []


notFound : String -> Model -> Html Msg
notFound path model =
    section [ class "section" ]
        [ div [ class "container" ]
            [ h1 [ class "title" ]
                [ text <| "unknown location " ++ path ]
            , p [ class "subtitle" ]
                [ a [ href <| Router.url Router.Home ] [ text "Go back home." ]
                ]
            ]
        ]
