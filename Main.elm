module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (..)
import Chart


type alias Model =
    { title : String
    , chartWidth : Int
    , chartHeight : Int
    , xAxis : Chart.XAxis
    , yAxis : Chart.YAxis
    , newValue : String
    }


type Msg
    = NoOp
    | InputValue String
    | AddValue String


initmodel : Model
initmodel =
    { title = "Chart title"
    , chartWidth = 1300
    , chartHeight = 700
    , xAxis =
        { label = "X"
        , values = [ "12月", "11月", "10月", "9月", "8月", "7月", "6月", "5月", "4月", "3月", "2月", "1月" ]
        }
    , yAxis =
        { label = "Y"
        , color = "green"
        , values = [ 201, 195, 197, 203, 200, 201, 198, 190, 187, 188, 185, 180 ]
        }
    , newValue = ""
    }


setYAxis : Chart.YAxis -> Model -> Model
setYAxis yAxis model =
    { model | yAxis = yAxis }


asYAxisIn : Model -> Chart.YAxis -> Model
asYAxisIn =
    flip setYAxis


setValues : List Int -> Chart.YAxis -> Chart.YAxis
setValues newlist yAxis =
    { yAxis | values = newlist }


asValuesIn : Chart.YAxis -> List Int -> Chart.YAxis
asValuesIn =
    flip setValues


init : ( Model, Cmd Msg )
init =
    ( initmodel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! [ Cmd.none ]

        InputValue value ->
            { model | newValue = value } ! [ Cmd.none ]

        AddValue value ->
            case String.toInt value of
                Err _ ->
                    model ! [ Cmd.none ]

                Ok intVal ->
                    ((intVal :: model.yAxis.values)
                        |> asValuesIn model.yAxis
                        |> asYAxisIn { model | newValue = "" }
                    )
                        ! [ Cmd.none ]


view : Model -> Html Msg
view model =
    div []
        [ text (toString (List.reverse model.yAxis.values))
        , form [ onSubmit (AddValue model.newValue) ]
            [ input
                [ onInput InputValue
                , placeholder "Insert a new value"
                , value model.newValue
                ]
                []
            , button [] [ text "OK" ]
            ]
        , br [] []
        , Chart.viewChart model
        ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }