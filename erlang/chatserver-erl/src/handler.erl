-module(handler).

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).
-export([main/0]).

main() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    Nicklist = dict:new(),
    {ok, Nicklist}.

handle_call({connect, Socket, Nickname}, _From, Nicklist) ->
    Response =
        case dict:is_key(Nickname, Nicklist) of
            true ->
                NewNicklist = Nicklist,
                err_nicknameinuse;
            false ->
                NewNicklist = dict:append(Nickname, Socket, Nicklist),
                {ok, display_nicklist(NewNicklist)}
        end,
    {reply, Response, NewNicklist};
handle_call({quit, Nickname}, _From, Nicklist) ->
    Response =
        case dict:is_key(Nickname, Nicklist) of
            true ->
                NewNicklist = dict:erase(Nickname, Nicklist),
                ok;
            false ->
                NewNicklist = Nicklist,
                user_not_found
        end,
    {reply, Response, NewNicklist};
handle_call(_Message, _From, State) ->
    {reply, error, State}.

handle_cast({privmsg, Nickname, Dest, Message}, Nicklist) ->
    User = dict:find(Dest, Nicklist),
    case User of
        {ok, [Socket | _]} ->
            gen_tcp:send(Socket, "> PRIVMSG :" ++ Nickname ++ " " ++ Message ++ "\n");
        _ ->
            ok
    end,
    {noreply, Nicklist};
handle_cast({join, Nickname}, Nicklist) ->
    broadcast(Nickname, "> JOIN :" ++ Nickname ++ "\n", Nicklist),
    {noreply, Nicklist};
handle_cast({quit, Nickname}, Nicklist) ->
    broadcast(Nickname, "> QUIT :" ++ Nickname ++ "\n", Nicklist),
    {noreply, Nicklist};
handle_cast(_Message, State) ->
    {noreply, State}.

broadcast(Nickname, Message, Nicklist) ->
    Sockets =
        lists:map(fun({_, [Value | _]}) -> Value end,
                  dict:to_list(
                      dict:erase(Nickname, Nicklist))),
    lists:foreach(fun(Socket) -> gen_tcp:send(Socket, Message) end, Sockets).

display_nicklist(Nicklist) ->
    Nicks = dict:fetch_keys(Nicklist),
    string:join(Nicks, " ").

handle_info(_Message, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.
