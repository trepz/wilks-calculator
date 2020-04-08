module Main exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
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
    , total : Float
    }


type Gender
    = Male
    | Female


type Units
    = LB
    | KG


init : () -> ( Model, Cmd Msg )
init _ =
    ( { gender = Male
      , units = KG
      , total = 0
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ToggleGender
    | ToggleUnits
    | UpdateTotal String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleGender ->
            ( { model
                | gender =
                    case model.gender of
                        Male ->
                            Female

                        Female ->
                            Male
              }
            , Cmd.none
            )

        ToggleUnits ->
            ( { model
                | units =
                    case model.units of
                        KG ->
                            LB

                        LB ->
                            KG
              }
            , Cmd.none
            )

        UpdateTotal total ->
            ( { model
                | total =
                    case String.toFloat total of
                        Just n ->
                            n

                        Nothing ->
                            0
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button
                [ onClick ToggleUnits ]
                [ text
                    (case model.units of
                        KG ->
                            "KG"

                        LB ->
                            "LBS"
                    )
                ]
            , button
                [ onClick ToggleGender ]
                [ text
                    (case model.gender of
                        Male ->
                            "Male"

                        Female ->
                            "Female"
                    )
                ]
            ]
        , div []
            [ input [ placeholder "Total", onInput UpdateTotal ] [] ]
        , div []
            [ text ("nice total bro: " ++ String.fromFloat model.total) ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
