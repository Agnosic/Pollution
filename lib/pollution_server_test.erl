%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Apr 2019 23:25
%%%-------------------------------------------------------------------
-module(pollution_server_test).
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
  ReturnValue = pollution_server:start(),
  pollution_server:stop(),
  ?assertEqual(true, ReturnValue).

stopTest() ->
  pollution_server:start(),
  ReturnValue = pollution_server:stop(),
  ?assertEqual(stop, ReturnValue).

addStationTest() ->
  pollution_server:start(),
  Value = pollution_server:addStation("Aleja", {50.2345, 18.3445}),
  pollution_server:stop(),
  ?assertEqual(Value, {addStation,"Aleja",{50.2345,18.3445}}).


addValueTest() ->
  pollution_server:start(),
  pollution_server:addStation("Aleja", {50.2345, 18.3445}),
  Value = pollution_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59),
  pollution_server:stop(),
  ?assertEqual(Value, {addValue,{50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59}).

removeValueTest() ->
  pollution_server:start(),
  pollution_server:addStation("Aleja", {50.2345, 18.3445}),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59),
  Value = pollution_server:removeValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10"),
  pollution_server:stop(),
  ?assertEqual(Value, {removeValue,{50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10"}).

getOneValueTest() ->
  pollution_server:start(),
  pollution_server:addStation("Aleja", {50.2345, 18.3445}),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59),
  pollution_server:addValue("Aleja", {{2019,3,20},{19,28,13}}, "PM10", 63),
  Value1 = pollution_server:getOneValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10"),
  pollution_server:stop(),
  ?assertEqual(Value1, {getOneValue,{50.2345,18.3445},{{2019,3,20},{19,58,13}},"PM10"}).

getStationMeanTest() ->
  pollution_server:start(),
  pollution_server:addStation("Aleja", {50.2345, 18.3445}),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,28,13}}, "PM10", 63),
  Value = pollution_server:getStationMean({50.2345, 18.3445}, "PM10"),
  pollution_server:stop(),
  ?assertEqual(Value, {getStationMean,{50.2345,18.3445},"PM10"}).

getDailyMeanTest() ->
  pollution_server:start(),
  pollution_server:addStation("Aleja", {50.2345, 18.3445}),
  pollution_server:addStation("ASD", {20.2345, 19.3}),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,28,13}}, "PM10", 63),
  pollution_server:addValue({20.2345, 19.3}, {{2019,3,20},{19,28,13}}, "PM10", 1),
  Value = pollution_server:getDailyMean({2019,3,20}, "PM10"),
  pollution_server:stop(),
  ?assertEqual(Value, {getDailyMean,{2019,3,20},"PM10"}).

getDeviationTest() ->
  pollution_server:start(),
  pollution_server:addStation("Aleja Slowackiego", {50.2345, 18.3445}),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,21},{19,58,13}}, "PM10", 59),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,24},{20,58,14}}, "PM10", 61),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,20},{19,20,13}}, "PM10", 51),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,25},{19,10,12}}, "PM10", 51),
  pollution_server:addValue({50.2345, 18.3445}, {{2019,3,20},{20,20,14}}, "PM10", 61),
  Value = pollution_server:getDeviation("PM10", 19),
  ?assertEqual(Value, {getDeviation,"PM10", 19}).