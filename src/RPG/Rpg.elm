module RPG.Rpg exposing (..)

import RPG.Wardice as Wardice
import RPG.Utils as Utils
import Json.Decode
import Json.Encode
import Json.Decode.Extra exposing ((|:))


type alias Nick =
    { nick : String }


type alias RollSet =
    { dices : List Wardice.Dice }


type alias RollDiceResult =
    { nick : String
    , results : List Wardice.DiceResult
    }


type alias ChatMessage =
    { nick : String, message : String }


type alias WSError =
    { message : String }


type MessageOut
    = SetNick Nick
    | RollDice { dices : List Wardice.Dice }
    | NewChatMessage ChatMessage


setNickEncoder : String -> Json.Encode.Value
setNickEncoder nick =
    Json.Encode.object
        [ ( "cmd", Json.Encode.string "SetNick" )
        , ( "nick", Json.Encode.string nick )
        ]


rollDicesEncoder : List Wardice.Dice -> Json.Encode.Value
rollDicesEncoder dices =
    Json.Encode.object
        [ ( "cmd", Json.Encode.string "RollDice" )
        , ( "dices", Json.Encode.list <| List.map Wardice.diceEncoder dices )
        ]


chatMessageEncoder : ChatMessage -> Json.Encode.Value
chatMessageEncoder chatMessage =
    Json.Encode.object
        [ ( "cmd", Json.Encode.string "NewChatMessage" )
        , ( "nick", Json.Encode.string chatMessage.nick )
        , ( "message", Json.Encode.string chatMessage.message )
        ]


type MessageIn
    = OnNewClient Nick
    | OnClientLeave Nick
    | OnRollDice RollDiceResult
    | OnChatMessage ChatMessage
    | Error WSError


parseMessageIn : String -> MessageIn
parseMessageIn str =
    Json.Decode.decodeString messageInDecoder str
        |> Result.mapError (\err -> Error { message = err })
        |> Utils.resolveResult


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

                    "OnRollDice" ->
                        Json.Decode.map OnRollDice
                            (Json.Decode.succeed RollDiceResult
                                |: Json.Decode.field "nick" Json.Decode.string
                                |: Json.Decode.field "results" (Json.Decode.list Wardice.diceResultDecoder)
                            )

                    "OnChatMessage" ->
                        Json.Decode.map OnChatMessage
                            (Json.Decode.succeed ChatMessage
                                |: Json.Decode.field "nick" Json.Decode.string
                                |: Json.Decode.field "message" Json.Decode.string
                            )

                    "Error" ->
                        Json.Decode.map Error
                            (Json.Decode.succeed WSError
                                |: Json.Decode.field "message" Json.Decode.string
                            )

                    _ ->
                        Json.Decode.fail "unknow value"
            )
