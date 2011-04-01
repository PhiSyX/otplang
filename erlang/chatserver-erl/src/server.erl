-module(server).

-export([connect/1, preprocess/1]).

connect(Port) ->
    handler:main(),
    tcpip:main(?MODULE, Port, {?MODULE, preprocess}).

preprocess(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            io:format("$ DATA: ~p~n", [trim_eol(binary_to_list(Data))]),
            RawData = trim_eol(binary_to_list(Data)),
            {Command, [_ | Nickname]} = lists:splitwith(fun(T) -> [T] =/= " " end, RawData),
            io:format("$ NICKNAME: ~p~n", [Nickname]),

            case Command of
                "CONNECT" ->
                    try_connect(Socket, Nickname);
                _ ->
                    gen_tcp:send(Socket, "Unknown command\r\n"),
                    ok
            end;
        {error, closed} ->
            ok
    end.

try_connect(Socket, Nickname) ->
    Res = gen_server:call(handler, {connect, Socket, Nickname}),
    case Res of
        {ok, Nicklist} ->
            gen_tcp:send(Socket, "> NICKLIST :" ++ Nicklist ++ "\r\n"),
            gen_server:cast(handler, {join, Nickname}),
            process(Socket, Nickname);
        err_nicknameinuse ->
            gen_tcp:send(Socket, "> ERROR :Nickname in use.\r\n"),
            ok
    end.

process(Socket, Nickname) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            io:format("$ DATA: ~p~n", [trim_eol(binary_to_list(Data))]),
            RawData = trim_eol(binary_to_list(Data)),
            {Command, [_ | RawMessage]} = lists:splitwith(fun(T) -> [T] =/= " " end, RawData),
            case Command of
                "PRIVMSG" ->
                    {Dest, [_ | Message]} = lists:splitwith(fun(T) -> [T] =/= " " end, RawMessage),
                    handle_command_privmsg(Socket, Nickname, Dest, Message);
                "QUIT" ->
                    handle_command_quit(Socket, Nickname)
            end;
        {error, closed} ->
            ok
    end.

handle_command_privmsg(Socket, Nickname, Dest, Message) ->
    gen_server:cast(handler, {privmsg, Nickname, Dest, Message}),
    process(Socket, Nickname).

handle_command_quit(Socket, Nickname) ->
    Res = gen_server:call(handler, {quit, Nickname}),
    case Res of
        ok ->
            gen_tcp:send(Socket, "> QUIT :Client Quit ("  ++ Nickname ++ ").\r\n"),
            gen_server:cast(handler, {quit, Nickname}),
            ok;
        _ ->
            gen_tcp:send(Socket, "> QUIT :Broken Pipe.\r\n"),
            ok
    end.

trim_eol(Data) ->
    Temp = string:strip(Data, right, $\n),
    string:strip(Temp, right, $\r).
