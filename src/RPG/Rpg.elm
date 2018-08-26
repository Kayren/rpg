module RPG.Rpg exposing (..)

import Rpg.Wardice exposing (Dice)
import Json

type alias Nick =
    { nick : String }

type alias RollSet : { dices : List Dice }

type alias RollResult =
    { nickname : String
    , results : List DiceResult
    }


type alias Error =
    { message : String }


type MessageOut
    = SetNick Nick
    | RollDice { dices : List Dice }


setNickEncoder : String -> Json.Encode.Value
setNickEncoder nick =
    Json.Encode.object
        [ ( "cmd", Json.Encode.string "SetNick" )
        , ( "nick", Json.Encode.string nick )
        ]


rollDicesEncoder : List Dice -> Json.Encode.Value
rollDicesEncoder dices =
    Json.Encode.object
        [ ( "cmd", Json.Encode.string "RollDice" )
        , ( "dices", Json.Encode.list <| List.map diceEncoder dices )
        ]


type MessageIn
    = OnNewClient Nick
    | OnClientLeave Nick
    | OnRollDicesResult RollResult
    | Error Error


messageInDecoder : Json.Decode.Decoder MessageIn
messageInDecoder =
    Json.Decode.field "cmd" Json.Decode.string
        |> Json.Decode.andThen
            (\str ->
                case str of
                    "OnNewClient" ->
                        Json.Decode.map OnNewClient
                            (Json.Decode.succeed Nick
                                |: Json.Decode.field "nick" Json.Decode.string
                            )

                    "OnClientLeave" ->
                        Json.Decode.map OnClientLeave
                            (Json.Decode.succeed Nick
                                |: Json.Decode.field "nick" Json.Decode.string
                            )

                    "OnRollDicesResult" ->
                        Json.Decode.map OnRollDicesResult
                            (Json.Decode.succeed RollResult
                                |: Json.Decode.field "nick" Json.Decode.string
                                |: Json.Decode.field "result" (Json.Decode.list diceResultDecoder)
                            )

                    "Error" ->
                        Json.Decode.map Error
                            (Json.Decode.succeed Error
                                |: Json.Decode.field "message" Json.Decode.string
                            )

                    _ ->
                        Json.Decode.fail "unknow value"
            )
