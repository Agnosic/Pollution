%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Apr 2019 02:04
%%%-------------------------------------------------------------------
-module(pollution_test).
-author("jan").
-include_lib("eunit/include/eunit.hrl").

%% API
-export([test/0, createMonitorTest/0, addStationTest/0, addValueTest/0, getOneValueTest/0, getStationMeanTest/0, getDailyMeanTest/0, getDeviationTest/0]).



-record(monitor, {stations=[]}).

test() ->
  ?assertEqual(createMonitorTest(), ok),
  ?assertEqual(addStationTest(), ok),
  ?assertEqual(addValueTest(), ok),
  ?assertEqual(getOneValueTest(), ok),
  ?assertEqual(getStationMeanTest(), ok),
  ?assertEqual(getDailyMeanTest(), ok),
  ?assertEqual(getDeviationTest(), ok).



createMonitorTest() ->
  ?assertEqual(#monitor{}, pollution:createMonitor()).

addStationTest() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Aleja Słowackiego", {50.2345, 18.3445}, P),
  P2 = pollution:addStation("Aleja Glowackiego", {50.2345, 18.21}, P1),
  ?assertEqual(pollution:addStation("Aleja Glowackiego", {50.2345, 18.1}, P2), {error, "There is already a station with that name"}),
  ?assertEqual(pollution:addStation("Aleja dsa", {50.2345, 18.21}, P2), {error, "There is already a station with that coordinates"}).

addValueTest() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Aleja Slowackiego", {50.2345, 18.3445}, P),
  P2 = pollution:addStation("Aleja Glowackiego", {50.2345, 18.21}, P1),
  P3 = pollution:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59, P2),
  P4 = pollution:addValue({50.2345, 18.21}, {{2019,3,20},{19,58,13}}, "PM10", 61, P3),
  ?assertEqual(pollution:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59, P4), {error, "Can't add measurment of the same data time and type and measurments"}),
  ?assertEqual(pollution:addValue("Alejka", {{2019,3,20},{19,58,13}}, "PM10", 59, P4), {error, "Station or Measurments not in dictionery"}).

getOneValueTest() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Aleja Slowackiego", {50.2345, 18.3445}, P),
  P2 = pollution:addStation("Aleja Glowackiego", {50.2345, 18.21}, P1),
  P3 = pollution:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59, P2),
  P4 = pollution:addValue({50.2345, 18.21}, {{2019,3,20},{19,58,13}}, "PM10", 61, P3),
  ?assertEqual(pollution:getOneValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", P4),59),
  ?assertEqual(pollution:getOneValue("Aleja Glowackiego", {{2019,3,20},{19,58,13}}, "PM10", P4),61).

getStationMeanTest() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Aleja Slowackiego", {50.2345, 18.3445}, P),
  P2 = pollution:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59, P1),
  P3 = pollution:addValue({50.2345, 18.3445}, {{2019,3,20},{20,58,14}}, "PM10", 61, P2),
  ?assertEqual(pollution:getStationMean({50.2345, 18.3445}, "PM10", P3), 60.0).

getDailyMeanTest() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Aleja Slowackiego", {50.2345, 18.3445}, P),
  P2 = pollution:addStation("Aleja Glowackiego", {50.2345, 18.21}, P1),
  P3 = pollution:addValue({50.2345, 18.3445}, {{2019,3,20},{19,58,13}}, "PM10", 59, P2),
  P4 = pollution:addValue({50.2345, 18.21}, {{2019,3,20},{19,58,13}}, "PM10", 61, P3),
  ?assertEqual(pollution:getDailyMean({2019,3,20}, "PM10", P4), 60.0).

getDeviationTest() ->
  P = pollution:createMonitor(),
  P1 = pollution:addStation("Aleja Slowackiego", {50.2345, 18.3445}, P),
  P2 = pollution:addValue({50.2345, 18.3445}, {{2019,3,21},{19,58,13}}, "PM10", 59, P1),
  P3 = pollution:addValue({50.2345, 18.3445}, {{2019,3,24},{20,58,14}}, "PM10", 61, P2),
  P4 = pollution:addValue({50.2345, 18.3445}, {{2019,3,20},{19,20,13}}, "PM10", 51, P3),
  P5 = pollution:addValue({50.2345, 18.3445}, {{2019,3,25},{19,10,12}}, "PM10", 51, P4),
  P6 = pollution:addValue({50.2345, 18.3445}, {{2019,3,20},{20,20,14}}, "PM10", 61, P5),
  ?assertEqual(pollution:getDeviation("PM10", 20, P6), 0.0),
  ?assertEqual(pollution:getDeviation("PM10", 19, P6), 4.618802153517007).
