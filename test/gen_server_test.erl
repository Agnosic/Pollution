%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Apr 2019 21:36
%%%-------------------------------------------------------------------
-module(gen_server_test).
-author("jan").
-include_lib("eunit/include/eunit.hrl").

%% API
-export([startTest/0, stopTest/0,addStationTest/0, addValueTest/0, removeValueTest/0, getOneValueTest/0, getStationMeanTest/0, getDailyMeanTest/0, getDeviationTest/0]).



%%test() ->
%%  ?assertEqual(startTest(), ok),
%%  ?assertEqual(stopTest(), ok),
%%  ?assertEqual(addStationTest(), ok),
%%  ?assertEqual(addValueTest(), ok),
%%  ?assertEqual(removeValueTest(), ok),
%%  ?assertEqual(getOneValueTest(), ok),
%%  ?assertEqual(getStationMeanTest(), ok),
%%  ?assertEqual(getDailyMeanTest(), ok),
%%  ?assertEqual(getDeviationTest(), ok).



startTest() ->
  {ReturnValue, _} = pollution_gen_server:start(),
  pollution_gen_server:stop(),
  ets:delete(table),
  ?assertEqual(ok, ReturnValue).

stopTest() ->
  pollution_gen_server:start(),
  ReturnValue = pollution_gen_server:stop(),
  ets:delete(table),
  ?assertEqual(ok, ReturnValue).

addStationTest() ->
  pollution_gen_server:start(),
  Value = pollution_gen_server:addStation("Aleja", {50.2345, 18.3445}),
  pollution_gen_server:stop(),
  Value1 = {monitor,[{station,"Aleja",{50.2345,18.3445},[]}]},
  ets:delete(table),
  ?assertEqual(Value, Value1).


addValueTest() ->
  pollution_gen_server:start(),
  pollution_gen_server:addStation("Aleja", {50.2345, 18.3445}),
  Value = pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59),
  pollution_gen_server:stop(),
  Value1 = {monitor,[{station,"Aleja",
    {50.2345,18.3445},
    [{measurment,{{2019,3,20},{19,58,13}},"PM10",59}]}]},
  ets:delete(table),
  ?assertEqual(Value, Value1).

removeValueTest() ->
  pollution_gen_server:start(),
  pollution_gen_server:addStation("Aleja", {50.2345, 18.3445}),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59),
  Value = pollution_gen_server:removeValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10"),
  pollution_gen_server:stop(),
  Value1 = {monitor,[{station,"Aleja",{50.2345,18.3445},[]}]},
  ets:delete(table),
  ?assertEqual(Value, Value1).

getOneValueTest() ->
  pollution_gen_server:start(),
  pollution_gen_server:addStation("Aleja", {50.2345, 18.3445}),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59),
  pollution_gen_server:addValue("Aleja", {{2019,3,20},{19,28,13}}, "PM10", 63),
  Value1 = pollution_gen_server:getOneValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10"),
  pollution_gen_server:stop(),
  ets:delete(table),
  ?assertEqual(Value1, 59).

getStationMeanTest() ->
  pollution_gen_server:start(),
  pollution_gen_server:addStation("Aleja", {50.2345, 18.3445}),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,28,13}}, "PM10", 63),
  Value = pollution_gen_server:getStationMean({50.2345, 18.3445}, "PM10"),
  pollution_gen_server:stop(),
  ets:delete(table),
  ?assertEqual(Value, 61.0).

getDailyMeanTest() ->
  pollution_gen_server:start(),
  pollution_gen_server:addStation("Aleja", {50.2345, 18.3445}),
  pollution_gen_server:addStation("ASD", {20.2345, 19.3}),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,28,13}}, "PM10", 63),
  pollution_gen_server:addValue({20.2345, 19.3}, {{2019,3,20},{19,28,13}}, "PM10", 1),
  Value = pollution_gen_server:getDailyMean({2019,3,20}, "PM10"),
  pollution_gen_server:stop(),
  ets:delete(table),
  ?assertEqual(Value, 41).

getDeviationTest() ->
  pollution_gen_server:start(),
  pollution_gen_server:addStation("Aleja Slowackiego", {50.2345, 18.3445}),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,21},{19,58,13}}, "PM10", 59),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,24},{20,58,14}}, "PM10", 61),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,20,13}}, "PM10", 51),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,25},{19,10,12}}, "PM10", 51),
  pollution_gen_server:addValue({50.2345, 18.3445}, {{2019,3,20},{20,20,14}}, "PM10", 61),
  Value = pollution_gen_server:getDeviation("PM10", 19),
  pollution_gen_server:stop(),
  ets:delete(table),
  ?assertEqual(Value, 4.618802153517007).

