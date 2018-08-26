module Router exposing (..)

import Navigation
import UrlParser exposing ((</>))


type Route
    = Home
    | NotFound String


url : Route -> String
url route =
    case route of
        Home ->
            "#/"

        NotFound s ->
            s


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ UrlParser.map Home (UrlParser.top)
        , UrlParser.map NotFound (UrlParser.string) -- catch all
        ]


parseLocation : Navigation.Location -> Route
parseLocation location =
    case (UrlParser.parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFound "#"
