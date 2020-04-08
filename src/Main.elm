module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)



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
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ToggleGender
    | ToggleUnits


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



-- VIEW


view : Model -> Html Msg
view model =
    div []
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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
