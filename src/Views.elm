module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Router
import RPG.Rpg as Rpg


-- Login


login : Model -> Html Msg
login model =
    div [ class "container full-heigth" ]
        [ div [ class "columns is-centered" ]
            [ div [ class "column is-narrow is-fullheigth" ]
                [ div [ class "box login-box" ]
                    [ Html.form [ onSubmit Login ]
                        [ div [ class "field" ]
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
                            ]
                        , div [ class "control" ]
                            [ button [ class "button is-fullwidth is-uppercase is-danger", type_ "submit" ] [ text "se connecter" ] ]
                        ]
                    ]
                ]
            ]
        ]



-- Home


home : Model -> Html Msg
home model =
    div [ class "container full-height" ]
        [ div [ class "columns full-height" ]
            [ div [ class "column" ] []
            , div [ class "column thread" ]
                [ displayThread model.thread
                , displayInputThread model.chatMessage
                ]
            ]
        ]


displayThread : List Model.Message -> Html Msg
displayThread thread =
    thread
        |> List.reverse
        |> List.map parseThreadMessage
        |> div [ class "columns is-multiline thread-list", id "thread", style [] ]


parseThreadMessage : Model.Message -> Html Msg
parseThreadMessage message =
    case message of
        Model.Text data ->
            displayTextMessage data

        Model.Join data ->
            displayJoinMessage data

        Model.Leave data ->
            displayLeaveMessage data

        Model.Rolls data ->
            displayRollsMessage data

        Model.Error data ->
            displayErrorMessage data


displayTextMessage : Rpg.ChatMessage -> Html Msg
displayTextMessage data =
    div [ class "column is-narrow is-12" ]
        [ div [ class "thread-item" ]
            [ div [ class "thread-nickname" ] [ text data.nick ]
            , div [ class "thread-message" ] [ text data.message ]
            ]
        ]


displayJoinMessage : Rpg.Nick -> Html Msg
displayJoinMessage data =
    div [ class "column is-narrow is-12" ]
        [ div [ class "thread-item" ]
            [ div [ class "thread-nickname" ] [ text <| data.nick ++ " rejoint la partie" ]
            ]
        ]


displayLeaveMessage : Rpg.Nick -> Html Msg
displayLeaveMessage data =
    div [ class "column is-narrow is-12" ]
        [ div [ class "thread-item" ]
            [ div [ class "thread-nickname" ] [ text <| data.nick ++ " quitte la partie" ]
            ]
        ]


displayRollsMessage : Rpg.RollResult -> Html Msg
displayRollsMessage data =
    div [ class "column is-narrow is-12" ] [ text <| "rolls" ]


displayErrorMessage : Rpg.WSError -> Html Msg
displayErrorMessage data =
    div [ class "column is-narrow is-12" ] [ text <| "error " ++ data.message ]


displayInputThread : String -> Html Msg
displayInputThread message =
    Html.form [ class "thread-input", onSubmit NewChatMessage ]
        [ div [ class "field" ]
            [ div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "textarea"
                    , rows 2
                    , onInput UpdateChatMessage
                    , value message
                    , required True
                    ]
                    []
                ]
            ]
        , div [ class "control" ]
            [ button [ class "button is-fullwidth is-uppercase is-danger", type_ "submit" ] [ text "Envoyer" ] ]
        ]



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
