module Main exposing (main)

import Browser
import Html exposing (Html, button, div, input, option, select, text)
import Html.Attributes exposing (placeholder, value)
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
    , algorithm : Algorithm
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
      , algorithm = Wilks
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
    | UpdateAlgorithm Algorithm
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

        UpdateAlgorithm algo ->
            { model | algorithm = algo } |> update CalculateScore

        UpdateBodyweight amount ->
            { model | bodyweight = amount } |> update CalculateScore

        UpdateTotal total ->
            { model | total = total } |> update CalculateScore

        CalculateScore ->
            ( { model
                | score =
                    computeScore
                        model.algorithm
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
            , select [ onInput (UpdateAlgorithm << nameToAlgo) ]
                (List.map
                    (\f ->
                        option
                            [ value (algoToName f) ]
                            [ text (algoToName f) ]
                    )
                    [ Wilks, IPF, OldWilks, Gloss ]
                )
            ]
        , div []
            [ input [ placeholder "Bodyweight", onInput (UpdateBodyweight << floatOrZero) ] []
            , input [ placeholder "Total", onInput (UpdateTotal << floatOrZero) ] []
            ]
        , div []
            [ text ("nice total bro: " ++ String.fromFloat model.total) ]
        , div []
            [ text (algoToName model.algorithm ++ " score: " ++ String.fromFloat model.score) ]
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


algoToName : Algorithm -> String
algoToName algo =
    case algo of
        Wilks ->
            "Wilks"

        OldWilks ->
            "Wilks (old formula)"

        IPF ->
            "IPF"

        Gloss ->
            "Glossbrenner"


nameToAlgo : String -> Algorithm
nameToAlgo name =
    case name of
        "Wilks" ->
            Wilks

        "Wilks (old formula)" ->
            OldWilks

        "IPF" ->
            IPF

        "Glossbrenner" ->
            Gloss

        _ ->
            Wilks


computeScore : Algorithm -> Gender -> Float -> Float -> Float
computeScore algo gender bodyweight total =
    let
        w =
            bodyweight
    in
    case algo of
        Wilks ->
            let
                { a, b, c, d, e, f } =
                    case gender of
                        Male ->
                            { a = -0.0000000078
                            , b = 0.0000041543
                            , c = -0.0006430507
                            , d = -0.0126966343
                            , e = 11.998275341
                            , f = -82.5815609216
                            }

                        Female ->
                            { a = -0.0000000071
                            , b = 0.0000015978
                            , c = 0.0003282035
                            , d = -0.1389344062
                            , e = 16.2595764612
                            , f = -182.5406521018
                            }
            in
            total * 500 / (a * w ^ 5 + b * w ^ 4 + c * w ^ 3 + d * w ^ 2 + e * w + f)

        OldWilks ->
            let
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

        IPF ->
            let
                ln =
                    logBase e

                { a, b, c, d } =
                    case gender of
                        Male ->
                            { a = 310.67, b = 857.785, c = 53.216, d = 147.0835 }

                        Female ->
                            { a = 125.1435, b = 228.03, c = 34.5246, d = 86.8301 }
            in
            500 + 100 * (total - (a * ln w - b)) / (c * ln w - d)

        _ ->
            0
