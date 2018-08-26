module Model exposing (..)

import Router exposing (Route)


-- Model


type alias Model =
    { config : Config
    , route : Router.Route
    , nick : String
    , ready : Bool
    }


initModel : Flags -> Model
initModel flags =
    { config = flags.config
    , route = Router.Login
    , nick = ""
    , ready = False
    }


resetModel : Model -> Model
resetModel model =
    model
        |> setRoute Router.Login
        |> setNick ""
        |> setReady False


setConfig : Config -> Model -> Model
setConfig config model =
    { model | config = config }


setRoute : Route -> Model -> Model
setRoute route model =
    { model | route = route }


setNick : String -> Model -> Model
setNick nick model =
    { model | nick = nick }


setReady : Bool -> Model -> Model
setReady ready model =
    { model | ready = ready }



-- Config


type alias Config =
    { url : String
    }


initConfig : Config
initConfig =
    { url = "" }



-- Flags


type alias Flags =
    { config : Config
    }
