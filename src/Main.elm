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
    = UpdateGender Gender
    | UpdateUnits Units
    | UpdateTotal String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateGender gender ->
            ( { model | gender = gender }, Cmd.none )

        UpdateUnits units ->
            ( { model | units = units }, Cmd.none )

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
            [ input [ placeholder "Total", onInput UpdateTotal ] [] ]
        , div []
            [ text ("nice total bro: " ++ String.fromFloat model.total) ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
