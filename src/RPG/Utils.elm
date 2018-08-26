module RPG.Utils exposing (..)


resolveResult : Result a a -> a
resolveResult r =
    case r of
        Ok ok ->
            ok

        Err err ->
            err
