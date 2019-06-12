%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Apr 2019 22:15
%%%-------------------------------------------------------------------
-module(pollution_gen_server).
-behavior(gen_server).
-author("jan").

%% API
-compile(export_all).

start_link(InitialValue) ->
  [{Record, Monitor}] = ets:lookup(InitialValue, monitor),
  gen_server:start_link(
    {local, server},
    ?MODULE,
    {Record, Monitor}, []
  ).

init(InitialValue) ->
  {ok, InitialValue}.

start() ->
  try
    ets:delete(table)
  catch
    error: _ -> empty
  end,
  ets:new(table, [set, named_table, public]),
  ets:insert(table, pollution:createMonitor()),
  start_link(table).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stop() -> gen_server:cast(server, stop).

crash() -> gen_server:cast(server, crash).

handle_cast(stop, Monitor) ->
  {stop, normal, Monitor};

handle_cast(crash, Monitor) ->
  1 / 0,
  {noreply, Monitor}.

terminate(Reason, _Monitor) ->
  io:format("Server: exited with reason ~w~n", [Reason]),
  %ets:delete(table),
  ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


addStation(Name, Coordinates) ->
  gen_server:call(server, {addStation, Name, Coordinates}).

addValue(NameOrMeas, DataTime, Type, Value) ->
  gen_server:call(server, {addValue, NameOrMeas, DataTime, Type, Value}).

getOneValue(NameOrMeas, DataTime, Type) ->
  gen_server:call(server, {getOneValue, NameOrMeas, DataTime, Type}).

removeValue(NameOrMeas, DataTime, Type) ->
  gen_server:call(server, {removeValue, NameOrMeas, DataTime, Type}).

getStationMean(NameOrMeas, Type) ->
  gen_server:call(server, {getStationMean, NameOrMeas, Type}).

getDailyMean(Data, Type) ->
  gen_server:call(server, {getDailyMean, Data, Type}).

getDeviation(Type, Hour) ->
  gen_server:call(server, {getDeviation, Type, Hour}).

handle_call({addStation, Name, Coordinates}, _From, Monitor) ->
  NewMonitor = pollution:addStation(Name, Coordinates, Monitor),
  ets:insert(table, NewMonitor),
  {reply, NewMonitor, NewMonitor};

handle_call({addValue, NameOrMeas, DataTime, Type, Value}, _From, Monitor) ->
  NewMonitor = pollution:addValue(NameOrMeas, DataTime, Type, Value, Monitor),
  ets:insert(table, NewMonitor),
  {reply, NewMonitor, NewMonitor};

handle_call({getOneValue, NameOrMeas, DataTime, Type}, _From, Monitor) ->
  OneValue = pollution:getOneValue(NameOrMeas, DataTime, Type, Monitor),
  {reply, OneValue, Monitor};

handle_call({removeValue, NameOrMeas, DataTime, Type}, _From, Monitor) ->
  NewMonitor = pollution:removeValue(NameOrMeas, DataTime, Type, Monitor),
  ets:insert(table, NewMonitor),
  {reply, NewMonitor, NewMonitor};

handle_call({getStationMean, NameOrMeas, Type}, _From, Monitor) ->
  StationMean = pollution:getStationMean(NameOrMeas, Type, Monitor),
  {reply, StationMean, Monitor};

handle_call({getDailyMean, Data, Type}, _From, Monitor) ->
  DailyMean = pollution:getDailyMean(Data, Type, Monitor),
  {reply, DailyMean, Monitor};

handle_call({getDeviation, Type, Hour}, _From, Monitor) ->
  Deviation = pollution:getDeviation(Type, Hour, Monitor),
  {reply, Deviation, Monitor}.


