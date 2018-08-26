module Msg exposing (..)

import Navigation
import Router


type
    Msg
    -- Router
    = OnChangeLocation Navigation.Location
    | ChangeLocation Router.Route
      -- Login
    | UpdateNickname String
    | Login
      -- Chats
    | UpdateChatMessage String
    | NewChatMessage
      -- Server Response
    | OnMessage String
      -- NoOp
    | NoOp
