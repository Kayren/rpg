port module Main exposing (..)

import Model exposing (Model)
import Html exposing (Html)
import Msg
    exposing
        ( Msg(..)
        )
import Navigation
import Router exposing (Route)
import Task
import Views


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
    Sub.none



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
            model ! []

        -- NoOp
        NoOp ->
            model ! []



-- VIEW


view : Model -> Html Msg
view model =
    case model.route of
        Router.Login ->
            Views.login model

        Router.Home ->
            Views.home

        Router.NotFound path ->
            Views.notFound path model
