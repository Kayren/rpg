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
    ( Model.initModel
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
    route


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

        NoOp ->
            model ! []



-- VIEW


view : Model -> Html Msg
view model =
    case model.route of
        Router.Home ->
            Views.home

        Router.NotFound path ->
            Views.notFound path model
