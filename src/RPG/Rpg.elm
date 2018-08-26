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


type alias RollResult =
    { nickname : String
    , results : List Wardice.DiceResult
    }


type alias WSError =
    { message : String }


type MessageOut
    = SetNick Nick
    | RollDice { dices : List Wardice.Dice }


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


type MessageIn
    = OnNewClient Nick
    | OnClientLeave Nick
    | OnRollDicesResult RollResult
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

                    "OnRollDicesResult" ->
                        Json.Decode.map OnRollDicesResult
                            (Json.Decode.succeed RollResult
                                |: Json.Decode.field "nick" Json.Decode.string
                                |: Json.Decode.field "result" (Json.Decode.list Wardice.diceResultDecoder)
                            )

                    "Error" ->
                        Json.Decode.map Error
                            (Json.Decode.succeed WSError
                                |: Json.Decode.field "message" Json.Decode.string
                            )

                    _ ->
                        Json.Decode.fail "unknow value"
            )
