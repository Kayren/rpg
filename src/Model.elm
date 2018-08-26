module Model exposing (..)

import Router exposing (Route)
import RPG.Rpg as Rpg


-- Model


type alias Model =
    { config : Config
    , route : Router.Route
    , nick : String
    , ready : Bool
    , thread : List Message
    , chatMessage : String
    }


initModel : Flags -> Model
initModel flags =
    { config = flags.config
    , route = Router.Login
    , nick = ""
    , ready = False
    , thread = []
    , chatMessage = ""
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


setThread : List Message -> Model -> Model
setThread messages model =
    { model | thread = messages }


addMessage : Message -> Model -> Model
addMessage message model =
    { model | thread = (::) message model.thread }


setChatMessage : String -> Model -> Model
setChatMessage message model =
    { model | chatMessage = message }



-- Message


type Message
    = Text TextMessage
    | Join Rpg.Nick
    | Leave Rpg.Nick
    | Rolls Rpg.RollResult
    | Error Rpg.WSError


type alias TextMessage =
    { nick : String, message : String }



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
