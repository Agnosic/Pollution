%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Mar 2019 13:21
%%%-------------------------------------------------------------------
-module(qsort).
-author("jan").

%% API
-export([lessThan/2, grtEqThan/2, qs/1, randomElems/3, compareSpeeds/3, sumDigits/1, sumDigitsRem3/0]).

lessThan(List, Arg) ->
  [X || X <- List, X < Arg].

grtEqThan(List, Arg) ->
  [X || X <- List, X >= Arg].


qs([]) -> [];
qs([Pivot|Tail]) ->
  qs( lessThan(Tail,Pivot) ) ++ [Pivot] ++ qs( grtEqThan(Tail,Pivot) ).

randomElems(N,Min,Max)->
  [rand:uniform(Max-Min + 1) + Min -1 || _ <- lists:seq(1, N)].

compareSpeeds(List, Fun1, Fun2) ->
  {Time1, _} = timer:tc(Fun1, [List]),
  {Time2, _} = timer:tc(Fun2, [List]),
  io:format("Time of Fun1: ~p~n", [Time1]),
  io:format("Time of Fun2: ~p~n", [Time2]).

map(_, []) -> [];
map(Fun, List) -> [Fun(X) || X <- List].

filter(_, []) -> [];
filter(Fun, List) -> [X || X <- List, Fun(X)].


split(0) -> [];
split(N) -> split(N div 10) ++ [N rem 10].
sumDigits(N) -> lists:foldl(fun (X, Acc) -> X + Acc end, 0, split(N)).

sumDigitsRem3() -> lists:filter(fun (X) -> X rem 3 == 0 end, randomElems(1000000, 0, 1000000)).
