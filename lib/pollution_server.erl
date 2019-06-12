%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Apr 2019 21:41
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("jan").

%% API
-export([start/0, stop/0, addStation/2, addValue/4, removeValue/3, getOneValue/3, getStationMean/2, getDailyMean/2, getDeviation/2, crash/0, init/0]).

start() ->
  register(?MODULE, spawn(fun() -> init() end)).

init() ->
  P = pollution:createMonitor(),
  loop_pollution(P).

stop() -> ?MODULE ! stop.


loop_pollution(P) ->
  receive
    {addStation, Name, Coordinates} ->
      Pnext = pollution:addStation(Name, Coordinates, P),
      loop_pollution(Pnext);
    {addValue, NameOrMeas, DataTime, Type, Value} ->
      Pnext = pollution:addValue(NameOrMeas, DataTime, Type, Value, P),
      loop_pollution(Pnext);
    {removeValue, NameOrMeas, DataTime, Type} ->
      Pnext = pollution:removeValue(NameOrMeas, DataTime, Type, P),
      loop_pollution(Pnext);
    {getOneValue, NameOrMeas, DataTime, Type} ->
      OneValue = pollution:getOneValue(NameOrMeas, DataTime, Type, P),
      io:format("~w~n", [OneValue]),
      loop_pollution(P);
    {getStationMean, NameOrMeas, Type} ->
      StationMean = pollution:getStationMean(NameOrMeas, Type, P),
      io:format("~w~n", [StationMean]),
      loop_pollution(P);
    {getDailyMean, Data, Type} ->
      DailyMean = pollution:getDailyMean(Data, Type, P),
      io:format("~w~n", [DailyMean]),
      loop_pollution(P);
    {getDeviation, Type, Hour} ->
      Deviation = pollution:getDeviation(Type, Hour, P),
      io:format("~w~n", [Deviation]),
      loop_pollution(P);
    stop -> terminate();
    crash -> 1/ 0
  end.

addStation(Name, Coordinates) ->
  ?MODULE ! {addStation, Name, Coordinates}.

addValue(NameOrMeas, DataTime, Type, Value) ->
  ?MODULE ! {addValue, NameOrMeas, DataTime, Type, Value}.

removeValue(NameOrMeas, DataTime, Type) ->
  ?MODULE ! {removeValue, NameOrMeas, DataTime, Type}.

getOneValue(NameOrMeas, DataTime, Type) ->
  ?MODULE ! {getOneValue, NameOrMeas, DataTime, Type}.

getStationMean(NameOrMeas, Type) ->
  ?MODULE ! {getStationMean, NameOrMeas, Type}.

getDailyMean(Data, Type) ->
  ?MODULE ! {getDailyMean, Data, Type}.

getDeviation(Type, Hour) ->
  ?MODULE ! {getDeviation, Type, Hour}.

terminate() ->
  ok.

crash() ->
  ?MODULE ! crash.


