%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Mar 2019 22:31
%%%-------------------------------------------------------------------
-module(myLists).
-author("jan").

%% API
-export([contains/2, duplicateElements/1, sumFloats/1, sumFloats2/1, sumFloats2util/2]).

contains([], _) -> false;
contains([H|_], H) -> true;
contains([_|T], Value) -> contains(T, Value).

duplicateElements([]) -> [];
duplicateElements([H|T]) -> [H] ++ [H] ++ duplicateElements(T).

sumFloats([]) -> 0;
sumFloats([H|T]) when is_float(H) ->
  H + sumFloats(T);
sumFloats([_|T]) ->
  sumFloats(T).

sumFloats2(List) -> sumFloats2util(List, 0).

sumFloats2util([], Acc) -> Acc;
sumFloats2util([H|T], Acc) when is_float(H) -> sumFloats2util(T, Acc + H);
sumFloats2util([_|T], Acc) -> sumFloats2util(T, Acc).