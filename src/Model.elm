module Model exposing (..)

import Router exposing (Route)


-- Model


type alias Model =
    { config : Config
    , route : Router.Route
    }


initModel : Model
initModel =
    { config = initConfig
    , route = Router.Home
    }


resetModel : Model -> Model
resetModel model =
    model
        |> setRoute Router.Home


setConfig : Config -> Model -> Model
setConfig config model =
    { model | config = config }


setRoute : Route -> Model -> Model
setRoute route model =
    { model | route = route }



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
