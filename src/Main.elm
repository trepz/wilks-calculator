module Main exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onClick, onInput)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { gender : Gender
    , units : Units
    , bodyweight : Float
    , total : Float
    , score : Float
    }


type Gender
    = Male
    | Female


type Units
    = LB
    | KG


type Algorithm
    = Wilks
    | OldWilks
    | IPF
    | Gloss


init : () -> ( Model, Cmd Msg )
init _ =
    ( { gender = Male
      , units = KG
      , bodyweight = 90
      , total = 0
      , score = 0
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateGender Gender
    | UpdateUnits Units
    | UpdateBodyweight Float
    | UpdateTotal Float
    | CalculateScore


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateGender gender ->
            { model | gender = gender } |> update CalculateScore

        UpdateUnits units ->
            ( { model | units = units }, Cmd.none )

        UpdateBodyweight amount ->
            { model | bodyweight = amount } |> update CalculateScore

        UpdateTotal total ->
            { model | total = total } |> update CalculateScore

        CalculateScore ->
            ( { model
                | score =
                    computeScore
                        OldWilks
                        model.gender
                        model.bodyweight
                        model.total
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ case model.units of
                KG ->
                    button [ onClick (UpdateUnits LB) ] [ text "KG" ]

                LB ->
                    button [ onClick (UpdateUnits KG) ] [ text "LBS" ]
            , case model.gender of
                Male ->
                    button [ onClick (UpdateGender Female) ] [ text "Male" ]

                Female ->
                    button [ onClick (UpdateGender Male) ] [ text "Female" ]
            ]
        , div []
            [ input [ placeholder "Bodyweight", onInput (UpdateBodyweight << floatOrZero) ] []
            , input [ placeholder "Total", onInput (UpdateTotal << floatOrZero) ] []
            ]
        , div []
            [ text ("nice total bro: " ++ String.fromFloat model.total) ]
        , div []
            [ text (algoName OldWilks ++ " score: " ++ String.fromFloat model.score) ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- UTILS


floatOrZero : String -> Float
floatOrZero num =
    case String.toFloat num of
        Just n ->
            n

        Nothing ->
            0


algoName : Algorithm -> String
algoName algo =
    case algo of
        Wilks ->
            "Wilks"

        OldWilks ->
            "Wilks (old formula)"

        IPF ->
            "IPF"

        Gloss ->
            "Glossbrenner"


computeScore : Algorithm -> Gender -> Float -> Float -> Float
computeScore algo gender bodyweight total =
    case algo of
        OldWilks ->
            let
                w =
                    bodyweight

                { a, b, c, d, e, f } =
                    case gender of
                        Male ->
                            { a = -216.0475144
                            , b = 16.2606339
                            , c = -0.002388645
                            , d = -0.00113732
                            , e = 7.01863e-6
                            , f = -1.291e-8
                            }

                        Female ->
                            { a = 594.31747775582
                            , b = -27.23842536447
                            , c = 0.82112226871
                            , d = -0.00930733913
                            , e = 4.731582e-5
                            , f = -9.054e-8
                            }
            in
            total * (500 / (a + b * w + c * w ^ 2 + d * w ^ 3 + e * w ^ 4 + f * w ^ 5))

        _ ->
            0
