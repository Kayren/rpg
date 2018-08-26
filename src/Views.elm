module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Router


-- Login


login : Model -> Html Msg
login model =
    div [ class "container full-heigth" ]
        [ div [ class "columns is-centered" ]
            [ div [ class "column is-narrow is-fullheigth" ]
                [ div [ class "box login-box" ]
                    [ Html.form [ onSubmit Login ]
                        [ div [ class "control" ]
                            [ input
                                [ class "input"
                                , placeholder "pseudo"
                                , type_ "text"
                                , onInput UpdateNickname
                                , value model.nick
                                , required True
                                ]
                                []
                            ]
                        , div [ class "control" ]
                            [ button [ class "button is-fullwidth is-uppercase is-danger", type_ "submit" ] [ text "se connecter" ] ]
                        ]
                    ]
                ]
            ]
        ]



-- Home


home : Html Msg
home =
    div [] []



-- Not Found


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
