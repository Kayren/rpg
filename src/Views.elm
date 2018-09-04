module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Router
import RPG.Rpg as Rpg
import RPG.Wardice as Wardice
import Json.Decode
import MD5


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
    div [ class "full-height" ]
        [ div [ class "columns full-height" ]
            [ div [ class "column" ]
                [ displayDiceForm model.diceSet
                ]
            , div [ class "column is-4 thread" ]
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
        [ div [ class "thread-item", borderStyle data.nick ]
            [ div [ class "thread-nickname" ] [ text data.nick ]
            , div [ class "thread-message" ] [ text data.message ]
            ]
        ]


displayJoinMessage : Rpg.Nick -> Html Msg
displayJoinMessage data =
    div [ class "column is-narrow is-12" ]
        [ div [ class "thread-item", borderStyle data.nick ]
            [ div [ class "thread-nickname" ] [ text <| data.nick ++ " rejoint la partie" ]
            ]
        ]


displayLeaveMessage : Rpg.Nick -> Html Msg
displayLeaveMessage data =
    div [ class "column is-narrow is-12" ]
        [ div [ class "thread-item", borderStyle data.nick ]
            [ div [ class "thread-nickname" ] [ text <| data.nick ++ " quitte la partie" ]
            ]
        ]


displayRollsMessage : Rpg.RollDiceResult -> Html Msg
displayRollsMessage data =
    div [ class "column is-narrow is-12", borderStyle data.nick ]
        [ div [ class "thread-item" ]
            [ div [ class "thread-nickname" ] [ text <| data.nick ]
            , data.results
                |> List.map displayDiceResult
                |> div [ class "thread-roll-result" ]
            ]
        ]


displayDiceResult : ( Wardice.Dice, String ) -> Html Msg
displayDiceResult ( dice, face ) =
    let
        f =
            displayFace face
    in
        case dice of
            Wardice.Fortune ->
                div [ class "dice fortune" ] [ f ]

            Wardice.Misfortune ->
                div [ class "dice misfortune" ] [ f ]

            Wardice.Expertise ->
                div [ class "dice expertise" ] [ f ]

            Wardice.Characteristic ->
                div [ class "dice characteristic" ] [ f ]

            Wardice.Challenge ->
                div [ class "dice challenge" ] [ f ]

            Wardice.Conservative ->
                div [ class "dice conservative" ] [ f ]

            Wardice.Reckless ->
                div [ class "dice reckless" ] [ f ]


displayFace : String -> Html Msg
displayFace face =
    case String.length face of
        0 ->
            text ""

        1 ->
            div [ class "wardice" ] [ text face ]

        2 ->
            div [ class "two-symbols" ]
                [ div [ class "wardice" ] [ text <| String.left 1 face ]
                , div [ class "wardice" ] [ text <| String.right 1 face ]
                ]

        _ ->
            text "Error"


displayErrorMessage : Rpg.WSError -> Html Msg
displayErrorMessage data =
    div [ class "column is-narrow is-12" ]
        [ div [ class "thread-item" ]
            [ div [ class "thread-nickname is-danger" ] [ text <| data.message ]
            ]
        ]


borderStyle : String -> Html.Attribute Msg
borderStyle s =
    let
        color =
            MD5.hex s
                |> String.slice 0 6
                |> String.append "#"
                |> Debug.log "color"
    in
        style [ ( "border-left", "3px solid " ++ color ) ]


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
            [ button [ class "button is-fullwidth is-uppercase is-primary", type_ "submit" ] [ text "Envoyer" ] ]
        ]



-- Dice Form


displayDiceForm : Model.DiceSet -> Html Msg
displayDiceForm diceSet =
    div [ class "section" ]
        [ Html.form [ onSubmit RollDice ]
            [ div [ class "columns is-multiline" ]
                [ div [ class "column is-3" ]
                    [ div [ class "field is-horizontal" ]
                        [ div [ class "field-label" ] [ div [ class "dice characteristic" ] [] ]
                        , div [ class "field-body" ]
                            [ input
                                [ class "input"
                                , type_ "number"
                                , value <| Basics.toString diceSet.characteristic
                                , onInputNumber UpdateDiceSetCharacteristic
                                , Html.Attributes.min "0"
                                , step "1"
                                ]
                                []
                            ]
                        ]
                    ]
                ,div [class "column is-3"] [ div [ class "field is-horizontal" ]
                    [ div [ class "field-label" ] [ div [ class "dice challenge" ] [] ]
                    , div [ class "field-body" ]
                        [ input
                            [ class "input"
                            , type_ "number"
                            , value <| Basics.toString diceSet.challenge
                            , onInputNumber UpdateDiceSetChallenge
                            , Html.Attributes.min "0"
                            , step "1"
                            ]
                            []
                        ]
                    ]]
                , div [class "column is-3"] [div [ class "field is-horizontal" ]
                    [ div [ class "field-label" ] [ div [ class "dice conservative" ] [] ]
                    , div [ class "field-body" ]
                        [ input
                            [ class "input"
                            , type_ "number"
                            , value <| Basics.toString diceSet.conservative
                            , onInputNumber UpdateDiceSetConservative
                            , Html.Attributes.min "0"
                            , step "1"
                            ]
                            []
                        ]
                    ]]
                , div [ class "column is-3"] [div [ class "field is-horizontal" ]
                    [ div [ class "field-label" ] [ div [ class "dice reckless" ] [] ]
                    , div [ class "field-body" ]
                        [ input
                            [ class "input"
                            , type_ "number"
                            , value <| Basics.toString diceSet.reckless
                            , onInputNumber UpdateDiceSetReckless
                            , Html.Attributes.min "0"
                            , step "1"
                            ]
                            []
                        ]
                    ]]
                , div [ class "column is-3"] [div [ class "field is-horizontal" ]
                    [ div [ class "field-label" ] [ div [ class "dice fortune" ] [] ]
                    , div [ class "field-body" ]
                        [ input
                            [ class "input"
                            , type_ "number"
                            , value <| Basics.toString diceSet.fortune
                            , onInputNumber UpdateDiceSetFortune
                            , Html.Attributes.min "0"
                            , step "1"
                            ]
                            []
                        ]
                    ]]
                , div [ class "column is-3"] [div [ class "field is-horizontal" ]
                    [ div [ class "field-label" ] [ div [ class "dice misfortune" ] [] ]
                    , div [ class "field-body" ]
                        [ input
                            [ class "input"
                            , type_ "number"
                            , value <| Basics.toString diceSet.misfortune
                            , onInputNumber UpdateDiceSetMisfortune
                            , Html.Attributes.min "0"
                            , step "1"
                            ]
                            []
                        ]
                    ]]
                , div [ class "column is-3"] [div [ class "field is-horizontal" ]
                    [ div [ class "field-label" ] [ div [ class "dice expertise" ] [] ]
                    , div [ class "field-body" ]
                        [ input
                            [ class "input"
                            , type_ "number"
                            , value <| Basics.toString diceSet.expertise
                            , onInputNumber UpdateDiceSetExpertise
                            , Html.Attributes.min "0"
                            , step "1"
                            ]
                            []
                        ]
                    ]
                ]]
            , button [ class "button is-uppercase is-primary is-pulled-right", type_ "submit" ] [ text "Lancer les dés!!!" ]
            ]
        ]


onInputNumber : (Int -> Msg) -> Html.Attribute Msg
onInputNumber tagger =
    on "change"
        (targetValue
            |> Json.Decode.andThen
                (\str ->
                    case String.toInt str of
                        Ok i ->
                            Json.Decode.succeed i

                        Err msg ->
                            Json.Decode.fail msg
                )
            |> Json.Decode.map tagger
        )



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
