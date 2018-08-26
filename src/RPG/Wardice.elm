module RPG.Wardice exposing (..)

import Json


type alias DiceResult =
    ( Dice, String )


diceResultDecoder : Json.Decode.Decoder DiceResult
diceResultDecoder =
    Json.Decode.map2 (,) (index 0 diceDecoder) (index 1 string)


type Dice
    = Fortune
    | Misfortune
    | Expertise
    | Characteritic
    | Challenge
    | Conservative
    | Reckless


diceEncoder : Dice -> Json.Encode.Value
diceEncoder v =
    case v of
        Fortune ->
            Json.Encode.string "Fortune"

        Misortune ->
            Json.Encode.string "Misfortune"

        Expertise ->
            Json.Encode.string "Expertise"

        Characteritic ->
            Json.Encode.string "Characteritic"

        Challenge ->
            Json.Encode.string "Challenge"

        Conservative ->
            Json.Encode.string "Conservative"

        Reckless ->
            Json.Encode.string "Reckless"


diceDecoder : JSON.Decode.Decoder Dice
diceDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\str ->
                case str of
                    "Fortune" ->
                        Json.decode.succeed Fortune

                    "Misfortune" ->
                        Json.Decode.succeed Misfortune

                    "Expertise" ->
                        Json.Decode.succeed Expertise

                    "Characteristic" ->
                        Json.Decode.succeed Characteritic

                    "Challenge" ->
                        Json.Decode.succeed Challenge

                    "Conservative" ->
                        Json.Decode.succeed Conservative

                    "Reckless" ->
                        Json.Decode.succeed Reckless

                    _ ->
                        Json.Decode.fail "unknow value"
            )
