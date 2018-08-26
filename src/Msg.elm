module Msg exposing (..)

import Navigation
import Router


type
    Msg
    -- Router
    = OnChangeLocation Navigation.Location
    | ChangeLocation Router.Route
      -- NoOp
    | NoOp
