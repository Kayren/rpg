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
    , diceSet : DiceSet
    }


initModel : Flags -> Model
initModel flags =
    { config = flags.config
    , route = Router.Login
    , nick = ""
    , ready = False
    , thread = []
    , chatMessage = ""
    , diceSet = initDiceSet
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


setDiceSet : DiceSet -> Model -> Model
setDiceSet diceSet model =
    { model | diceSet = diceSet }



-- Message


type Message
    = Text TextMessage
    | Join Rpg.Nick
    | Leave Rpg.Nick
    | Rolls Rpg.RollDiceResult
    | Error Rpg.WSError


type alias TextMessage =
    { nick : String, message : String }



-- DiceSet


type alias DiceSet =
    { fortune : Int
    , misfortune : Int
    , expertise : Int
    , characteristic : Int
    , challenge : Int
    , conservative : Int
    , reckless : Int
    }


setDiceSetFortune : Int -> DiceSet -> DiceSet
setDiceSetFortune qte ds =
    { ds | fortune = qte }


setDiceSetMisfortune : Int -> DiceSet -> DiceSet
setDiceSetMisfortune qte ds =
    { ds | misfortune = qte }


setDiceSetExpertise : Int -> DiceSet -> DiceSet
setDiceSetExpertise qte ds =
    { ds | expertise = qte }


setDiceSetCharacteristic : Int -> DiceSet -> DiceSet
setDiceSetCharacteristic qte ds =
    { ds | characteristic = qte }


setDiceSetChallenge : Int -> DiceSet -> DiceSet
setDiceSetChallenge qte ds =
    { ds | challenge = qte }


setDiceSetConservative : Int -> DiceSet -> DiceSet
setDiceSetConservative qte ds =
    { ds | conservative = qte }


setDiceSetReckless : Int -> DiceSet -> DiceSet
setDiceSetReckless qte ds =
    { ds | reckless = qte }


initDiceSet : DiceSet
initDiceSet =
    { fortune = 0
    , misfortune = 0
    , expertise = 0
    , characteristic = 0
    , challenge = 0
    , conservative = 0
    , reckless = 0
    }



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
