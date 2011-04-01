-module(tcpip).

-behavior(gen_server).

-export([main/3]).
-export([init/1, handle_call/3, handle_cast/2]).
-export([process/1]).

-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]).

-record(state, {port, process, listen_socket = null}).

main(Name, Port, Process) ->
    State = #state{port = Port, process = Process},
    gen_server:start_link({local, Name}, ?MODULE, State, []).

init(State = #state{port = Port}) ->
    case gen_tcp:listen(Port, ?TCP_OPTIONS) of
        {ok, ListenSocket} ->
            NewState = State#state{listen_socket = ListenSocket},
            {ok, accept(NewState)};
        {error, Reason} ->
            {stop, Reason}
    end.

handle_cast({accepted, _Pid}, State = #state{}) ->
    {noreply, accept(State)}.

process({Server, ListenSocket, {Module, ProcessFn}}) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    gen_server:cast(Server, {accepted, self()}),
    Module:ProcessFn(Socket).

accept(State = #state{listen_socket = ListenSocket, process = Process}) ->
    proc_lib:spawn(?MODULE, process, [{self(), ListenSocket, Process}]),
    State.

handle_call(_Msg, _From, State) ->
    {noreply, State}.
