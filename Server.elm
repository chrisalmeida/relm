port module Server exposing (..)

import Starter exposing (..)


-- needed for runtime

import Json.Decode


elmApp : String
elmApp =
    """
    <html>
      <head>
        <script src="elm-app.js"></script>
      </head>
      <body>
        <div id="main"></div>
      </body>
      <script>
        Elm.Main.fullscreen()
      </script>
    </html>
    """


type Msg
    = IncomingMessage String
    | ReceivedRequest Request


type alias Model =
    { template : String, portNumber : Int }


model : Model
model =
    { template = elmApp
    , portNumber = 4500
    }


main : Program Never Model Msg
main =
    Platform.program
        { init = ( model, Starter.send "" )
        , subscriptions = subscriptions
        , update = update
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Starter.listen IncomingMessage
        , receivedRequest (\headers -> ReceivedRequest headers)
        ]


port startServer : Model -> Cmd msg


port receivedRequest : (Request -> msg) -> Sub msg


update : Msg -> Model -> ( Model, Cmd Msg )
update m model =
    case m of
        IncomingMessage message ->
            let
                l =
                    Debug.log "ELM LOG" "This is logging from within elm!"
            in
                ( model, startServer model )

        ReceivedRequest req ->
            let
                h =
                    Debug.log "Headers In Elm" req
            in
                ( model, Cmd.none )


type alias Headers =
    { host : String
    , connection : String
    , cacheControl : String
    , upgradeSecureRequests : String
    , userAgent : String
    , accept : String
    , acceptEncoding : String
    , acceptLanguage : String
    , cookie : String
    }


type alias Request =
    { url : String
    , headers : Headers
    }
