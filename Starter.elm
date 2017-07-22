effect module Starter where { subscription = MySub, command = MyCmd } exposing (..)

import Task exposing (..)


send : String -> Cmd msg
send message =
    command <| Send message


listen : (String -> msg) -> Sub msg
listen tagger =
    subscription <| Listen tagger


type MyCmd msg
    = Send String


type MySub msg
    = Listen (String -> msg)


cmdMap : (a -> b) -> MyCmd a -> MyCmd b
cmdMap tagger cmd =
    case cmd of
        Send string ->
            Send string


subMap : (a -> b) -> MySub a -> MySub b
subMap higherTagger sub =
    case sub of
        Listen tagger ->
            Listen <| tagger >> higherTagger


type alias State msg =
    { listeners : List (MySub msg) }


type SelfMsg
    = IncomingSend String


init : Task Never (State msg)
init =
    Task.succeed { listeners = [] }


onEffects :
    Platform.Router msg SelfMsg
    -> List (MyCmd msg)
    -> List (MySub msg)
    -> State msg
    -> Task Never (State msg)
onEffects router cmds subs oldState =
    let
        selfMsgTask =
            cmds
                |> List.map (\(Send message) -> message)
                |> List.map IncomingSend
                |> List.map (Platform.sendToSelf router)
                |> Task.sequence

        newState =
            { listeners = subs }
    in
        selfMsgTask |> Task.andThen (\_ -> Task.succeed newState)


onSelfMsg :
    Platform.Router msg SelfMsg
    -> SelfMsg
    -> State msg
    -> Task Never (State msg)
onSelfMsg router selfMsg oldState =
    case selfMsg of
        IncomingSend message ->
            let
                appMsgTask =
                    oldState.listeners
                        |> List.map
                            (\(Listen tagger) ->
                                tagger ("outgoing message: " ++ message)
                            )
                        |> List.map (Platform.sendToApp router)
                        |> Task.sequence
            in
                appMsgTask
                    |> Task.andThen (\_ -> Task.succeed oldState)
