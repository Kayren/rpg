module RPG.Wardice exposing (..)

import Json.Decode
import Json.Encode


type alias DiceResult =
    ( Dice, String )


diceResultDecoder : Json.Decode.Decoder DiceResult
diceResultDecoder =
    Json.Decode.map2 (,) (Json.Decode.index 0 diceDecoder) (Json.Decode.index 1 Json.Decode.string)


type Dice
    = Fortune
    | Misfortune
    | Expertise
    | Characteristic
    | Challenge
    | Conservative
    | Reckless


diceEncoder : Dice -> Json.Encode.Value
diceEncoder v =
    case v of
        Fortune ->
            Json.Encode.string "Fortune"

        Misfortune ->
            Json.Encode.string "Misfortune"

        Expertise ->
            Json.Encode.string "Expertise"

        Characteristic ->
            Json.Encode.string "Characteristic"

        Challenge ->
            Json.Encode.string "Challenge"

        Conservative ->
            Json.Encode.string "Conservative"

        Reckless ->
            Json.Encode.string "Reckless"


diceDecoder : Json.Decode.Decoder Dice
diceDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\str ->
                case str of
                    "Fortune" ->
                        Json.Decode.succeed Fortune

                    "Misfortune" ->
                        Json.Decode.succeed Misfortune

                    "Expertise" ->
                        Json.Decode.succeed Expertise

                    "Characteristic" ->
                        Json.Decode.succeed Characteristic

                    "Challenge" ->
                        Json.Decode.succeed Challenge

                    "Conservative" ->
                        Json.Decode.succeed Conservative

                    "Reckless" ->
                        Json.Decode.succeed Reckless

                    _ ->
                        Json.Decode.fail "unknow value"
            )
