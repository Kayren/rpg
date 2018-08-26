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
      -- DiceSet
    | UpdateDiceSetFortune Int
    | UpdateDiceSetMisfortune Int
    | UpdateDiceSetExpertise Int
    | UpdateDiceSetCharacteristic Int
    | UpdateDiceSetChallenge Int
    | UpdateDiceSetConservative Int
    | UpdateDiceSetReckless Int
    | RollDice
      -- Server Response
    | OnMessage String
      -- NoOp
    | NoOp
