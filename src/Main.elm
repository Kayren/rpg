port module Main exposing (..)

import Model exposing (Model, Message(..))
import Html exposing (Html)
import Msg
    exposing
        ( Msg(..)
        )
import Navigation
import Router exposing (Route)
import Json.Encode
import Json.Decode
import Task
import Views
import WebSocket as Ws
import RPG.Rpg as Rpg
import Dom.Scroll as Scroll


main : Program Model.Flags Model Msg
main =
    Navigation.programWithFlags OnChangeLocation
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Model.Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( Model.initModel flags
    , Task.succeed (OnChangeLocation location)
        |> Task.perform identity
    )



-- SUBS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Ws.listen model.config.url OnMessage ]



-- Router


filterRoute : Model -> Route -> Route
filterRoute model route =
    if model.ready then
        case route of
            Router.Login ->
                Router.Home

            _ ->
                route
    else
        Router.Login


gotoRoute : Route -> Cmd Msg
gotoRoute route =
    route
        |> Router.url
        |> Navigation.newUrl


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Router
        OnChangeLocation location ->
            ( Router.parseLocation location
                |> filterRoute model
                |> (flip Model.setRoute) model
            , Cmd.none
            )

        ChangeLocation route ->
            ( model, gotoRoute route )

        -- Login
        UpdateNickname nick ->
            (nick
                |> flip Model.setNick model
            )
                ! []

        Login ->
            model
                ! [ model.nick
                        |> Rpg.setNickEncoder
                        |> Json.Encode.encode 0
                        |> Ws.send model.config.url
                  ]

        -- Chats
        UpdateChatMessage message ->
            (message |> flip Model.setChatMessage model) ! []

        NewChatMessage ->
            (model |> Model.setChatMessage "")
                ! [ { nick = model.nick, message = model.chatMessage }
                        |> Debug.log "NewChatMessage"
                        |> Rpg.chatMessageEncoder
                        |> Json.Encode.encode 0
                        |> Ws.send model.config.url
                  ]

        -- Server Response
        OnMessage message ->
            Rpg.parseMessageIn message
                |> updateMessageIn model

        -- NoOp
        NoOp ->
            model ! []


updateMessageIn : Model -> Rpg.MessageIn -> ( Model, Cmd Msg )
updateMessageIn model msgIn =
    case msgIn of
        Rpg.OnNewClient data ->
            (Join data
                |> flip Model.addMessage model
                |> Model.setReady True
            )
                ! [ gotoRoute Router.Home
                  , Task.attempt (always NoOp) <| Scroll.toBottom "thread"
                  ]

        Rpg.OnClientLeave data ->
            (Leave data
                |> flip Model.addMessage model
            )
                ! [ Task.attempt (always NoOp) <| Scroll.toBottom "thread"
                  ]

        Rpg.OnRollDicesResult data ->
            (Rolls data
                |> flip Model.addMessage model
            )
                ! [ Task.attempt (always NoOp) <| Scroll.toBottom "thread"
                  ]

        Rpg.OnChatMessage data ->
            (Text data
                |> flip Model.addMessage model
            )
                ! [ Task.attempt (always NoOp) <| Scroll.toBottom "thread"
                  ]

        Rpg.Error data ->
            (Error data
                |> flip Model.addMessage model
            )
                ! [ Task.attempt (always NoOp) <| Scroll.toBottom "thread"
                  ]



-- VIEW


view : Model -> Html Msg
view model =
    case model.route of
        Router.Login ->
            Views.login model

        Router.Home ->
            Views.home model

        Router.NotFound path ->
            Views.notFound path model
