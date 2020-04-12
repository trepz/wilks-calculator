module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, button, div, input, option, select, text)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Svg exposing (path, svg)
import Svg.Attributes exposing (d, preserveAspectRatio, viewBox)



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
    , bodyweight : String
    , total : String
    , singleLifts : Dict String String
    , score : Float
    , mode : Mode
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


type Mode
    = Single
    | Total


type SvgPathAction
    = Q Int Int Int Int
    | M Int Int
    | L Int Int
    | Z


init : () -> ( Model, Cmd Msg )
init _ =
    ( { gender = Male
      , units = KG
      , algorithm = Wilks
      , bodyweight = "90"
      , total = ""
      , singleLifts =
            Dict.fromList
                [ ( "Squat", "" )
                , ( "Bench", "" )
                , ( "Deadlift", "" )
                ]
      , score = 0
      , mode = Total
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateGender Gender
    | UpdateUnits Units
    | UpdateAlgorithm Algorithm
    | UpdateBodyweight String
    | UpdateTotal String
    | UpdateLift String String
    | CalculateScore
    | UpdateMode Mode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateGender gender ->
            { model | gender = gender } |> update CalculateScore

        UpdateUnits units ->
            let
                convert =
                    convertWeight model.units units
            in
            ( { model
                | units = units
                , total = convert model.total
                , bodyweight = convert model.bodyweight
                , singleLifts = Dict.map (\_ v -> convert v) model.singleLifts
              }
            , Cmd.none
            )

        UpdateAlgorithm algo ->
            { model | algorithm = algo } |> update CalculateScore

        UpdateBodyweight amount ->
            { model | bodyweight = amount } |> update CalculateScore

        UpdateTotal total ->
            { model | total = total } |> update CalculateScore

        UpdateLift lift amount ->
            { model | singleLifts = Dict.insert lift amount model.singleLifts }
                |> update CalculateScore

        CalculateScore ->
            ( { model
                | score =
                    computeScore
                        model.algorithm
                        model.gender
                        (model.bodyweight |> convertWeight model.units KG |> floatOrZero)
                        (modeTotal model |> convertWeight model.units KG |> floatOrZero)
              }
            , Cmd.none
            )

        UpdateMode mode ->
            { model | mode = mode, total = modeTotal model } |> update CalculateScore



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model.score model.algorithm
        , div [ class "section inputs" ]
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
                ([ Wilks, IPF, OldWilks ]
                    |> List.map
                        (\f ->
                            option
                                [ value (algoToName f) ]
                                [ text (algoToName f) ]
                        )
                )
            , case model.mode of
                Single ->
                    button [ onClick (UpdateMode Total) ] [ text "Input: Total" ]

                Total ->
                    button [ onClick (UpdateMode Single) ] [ text "Input: Individual Lifts" ]
            , viewInput "Bodyweight" model.bodyweight UpdateBodyweight
            , case model.mode of
                Single ->
                    div []
                        (Dict.toList model.singleLifts
                            |> List.map (\( name, val ) -> viewInput name val (UpdateLift name))
                        )

                Total ->
                    div [] [ viewInput "Total" model.total UpdateTotal ]
            ]
        , div []
            [ text
                (if model.mode == Single then
                    "Total: " ++ modeTotal model

                 else
                    ""
                )
            ]
        ]


viewInput : String -> String -> (String -> Msg) -> Html Msg
viewInput p v toMsg =
    div [ class "input" ]
        [ input
            [ type_ "number"
            , class "input__field"
            , placeholder p
            , value v
            , onInput toMsg
            ]
            []
        ]


viewHeader : Float -> Algorithm -> Html Msg
viewHeader score algorithm =
    div [ class "header" ]
        [ div [ class "header__display" ]
            [ div [ class "header__score" ]
                [ roundToPlaces score 2
                    |> (\n ->
                            if n < 0 then
                                0

                            else
                                n
                       )
                    |> String.fromFloat
                    |> text
                ]
            , div [ class "header__formula" ] [ algorithm |> algoToName |> text ]
            ]
        , viewWave
        ]


viewWave : Html Msg
viewWave =
    div [ class "wave" ]
        [ svg
            [ preserveAspectRatio "none", viewBox "0 0 100 100" ]
            [ path
                [ [ M 0 50
                  , Q 25 100 50 50
                  , Q 75 0 100 50
                  , L 100 100
                  , L 0 100
                  , Z
                  ]
                    |> toPath
                    |> d
                ]
                []
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- UTILS


toPath : List SvgPathAction -> String
toPath coords =
    List.foldl
        (\coord str ->
            case coord of
                Q ax ay x y ->
                    str
                        ++ "Q"
                        ++ String.fromInt ax
                        ++ ","
                        ++ String.fromInt ay
                        ++ " "
                        ++ String.fromInt x
                        ++ ","
                        ++ String.fromInt y

                M x y ->
                    str ++ "M" ++ String.fromInt x ++ "," ++ String.fromInt y

                L x y ->
                    str ++ "L" ++ String.fromInt x ++ "," ++ String.fromInt y

                Z ->
                    str ++ "Z"
        )
        ""
        coords


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


nameToAlgo : String -> Algorithm
nameToAlgo name =
    case name of
        "Wilks" ->
            Wilks

        "Wilks (old formula)" ->
            OldWilks

        "IPF" ->
            IPF

        _ ->
            Wilks


modeTotal : Model -> String
modeTotal model =
    case model.mode of
        Total ->
            model.total

        Single ->
            model.singleLifts
                |> Dict.foldl (\_ n t -> floatOrZero n + t) 0
                |> String.fromFloat


convertWeight : Units -> Units -> String -> String
convertWeight from to stringN =
    let
        n =
            floatOrZero stringN

        m =
            if n == 0 then
                0

            else
                case ( from, to ) of
                    ( LB, KG ) ->
                        roundToPlaces (n / 2.2046226218488) 2

                    ( KG, LB ) ->
                        roundToPlaces (n * 2.2046226218488) 2

                    _ ->
                        n
    in
    String.fromFloat m


roundToPlaces : Float -> Float -> Float
roundToPlaces num places =
    let
        n =
            10 ^ places
    in
    toFloat (round (num * n)) / n


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
