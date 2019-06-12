%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Mar 2019 13:56
%%%-------------------------------------------------------------------
-module(pollution).
-author("jan").

%% API
-export([createMonitor/0, addStation/3, addValue/5, removeValue/4, getOneValue/4, getStationMean/3, getDailyMean/3, extractHour/1, getDeviation/3]).


-record(station, {name, coordinates, measurments=[]}).
-record(measurment, {datatime, type, value}).
-record(monitor, {stations=[]}).

createMonitor() ->
  #monitor{}.


addStation(Name, Coordinates, Monitor) ->
  FindN = fun(X) -> string:equal(X#station.name, Name)end,
  FoundN = lists:any(FindN, Monitor#monitor.stations),
  case FoundN of
    true -> io:format("There is already a station with that name~n"), Monitor;
    false ->
      FindC = fun(X) -> X#station.coordinates == Coordinates end,
      FoundC = lists:any(FindC, Monitor#monitor.stations),
      case FoundC of
        true -> io:format("There is already a station with that coordinates~n"), Monitor;
        false -> NewStations = Monitor#monitor.stations ++ [#station{name = Name, coordinates = Coordinates}],
          Monitor#monitor{stations = NewStations}
      end
  end.

addValue(NameOrMeas, DataTime, Type, Value, Monitor) ->
  Key = getKey(NameOrMeas, Monitor),
  case Key of
    false -> io:format("Station or Measurments not in dictionery~n"), Monitor;
    Station ->
      FindM = fun(X) -> (X#measurment.datatime == DataTime) and (string:equal(X#measurment.type, Type)) end,
      FoundM = lists:any(FindM, Station#station.measurments),
      case FoundM of
        true -> io:format("Can't add measurment of the same data time and type and measurments~n"), Monitor;
        false -> NewMeasurments = Station#station.measurments ++ [#measurment{datatime = DataTime, type = Type, value = Value}],
          NewStations = Station#station{measurments = NewMeasurments},
          Stations = lists:delete(Station, Monitor#monitor.stations),
          Monitor#monitor{stations = Stations ++ [NewStations]}
      end
  end.

getKey(NameOrMeas, Monitor) ->
  case is_tuple(NameOrMeas) of
    true -> lists:keyfind(NameOrMeas, #station.coordinates, Monitor#monitor.stations);
    false -> lists:keyfind(NameOrMeas, #station.name, Monitor#monitor.stations)
  end.




removeValue(NameOrMeas, DataTime, Type, Monitor) ->
  Key = getKey(NameOrMeas, Monitor),
  case Key of
    false -> io:format("Station not in dictionery~n"), Monitor;
    Station ->
      FindM = fun(X) -> (X#measurment.datatime == DataTime) and (string:equal(X#measurment.type, Type)) end,
      Measurments = lists:filter(FindM, Station#station.measurments),
      case Measurments of
        [] -> io:format("No such Measurment to delete~n"), Monitor;
        [H | _] -> Meas = H,
          NewMeasurments = lists:delete(Meas, Station#station.measurments),
          NewStations = Station#station{measurments = NewMeasurments},
          Stations = lists:delete(Station, Monitor#monitor.stations),
          Monitor#monitor{stations = Stations ++ [NewStations]}
      end
  end.

getOneValue(NameOrMeas, DataTime, Type, Monitor) ->
  Key = getKey(NameOrMeas, Monitor),
  case Key of
    false -> io:format("Station not in dictionery~n"), Monitor;
    Station ->
      FindM = fun(X) -> (X#measurment.datatime == DataTime) and (string:equal(X#measurment.type, Type)) end,
      Measurments = lists:filter(FindM, Station#station.measurments),
      case Measurments of
        [] -> io:format("No such Measurment~n"), Monitor;
        [H | _] -> H#measurment.value
      end
  end.

getStationMean(NameOrMeas, Type, Monitor) ->
  Key = getKey(NameOrMeas, Monitor),
  case Key of
    false -> io:format("Station not in dictionery~n"), Monitor;
    Station ->
      FindM = fun(X) -> string:equal(X#measurment.type, Type) end,
      Measurments = lists:filter(FindM, Station#station.measurments),
      case Measurments of
        [] -> io:format("No such Measurments~n"), Monitor;
        List -> Sum = lists:foldl(fun (X, Acc) -> X#measurment.value + Acc end, 0, List),
        Length = lists:foldl(fun (_, Acc) -> 1 + Acc end, 0, List),
        Sum / Length
      end
  end.

getDailyMean(Data, Type, Monitor) ->
  Stations = (Monitor#monitor.stations),
  case Stations of
    [] -> io:format("No stations~n"), Monitor;
    _ -> Measurments = lists:flatten([X#station.measurments || X <- Stations]),
      FilteredValues = [X || X <- Measurments, extractDate(X#measurment.datatime) == Data, string:equal(X#measurment.type, Type)],
      avg(FilteredValues)
  end.

extractDate(DataTime) ->
  {Date, _} = DataTime,
  Date.


getDeviation(Type, Hour, Monitor) ->
  Stations = Monitor#monitor.stations,
  case Stations of
    [] -> io:format("No stations~n"), Monitor;
    _ -> Measurments = lists:flatten([X#station.measurments || X <- Stations]),
      FilteredValues = [X || X <- Measurments, extractHour(X#measurment.datatime) == Hour, string:equal(X#measurment.type, Type)],
      Avg = avg(FilteredValues),
      Length = lists:foldl(fun (_, Acc) -> 1 + Acc end, 0, FilteredValues),
      case Length of
        1 -> 0;
        _ -> Variance = lists:foldl(fun (X, Acc) -> math:pow(X#measurment.value - Avg, 2) + Acc end, 0, FilteredValues)/(Length-1),
          math:sqrt(Variance)
      end
  end.

extractHour(DataTime) ->
  {_, Time} = DataTime,
  {Hour, _, _} = Time,
  Hour.

avg(FilteredValues) ->
  Sum = lists:foldl(fun (X, Acc) -> X#measurment.value + Acc end, 0, FilteredValues),
  Length = lists:foldl(fun (_, Acc) -> 1 + Acc end, 0, FilteredValues),
  Sum / Length.
