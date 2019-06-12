%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Mar 2019 20:57
%%%-------------------------------------------------------------------
-module(onp).
-author("jan").

%% API
-export([onp/1]).

onp(Line) ->
  onp_util(string:tokens(Line, " "), []).

onp_util([], [Value]) ->
  Value;

onp_util(["+" | T], [A | [B | StackT]]) ->
  onp_util(T, [B + A | StackT]);

onp_util(["-" | T], [A | [B | StackT]]) ->
  onp_util(T, [B - A | StackT]);

onp_util(["*" | T], [A | [B | StackT]]) ->
  onp_util(T, [B * A | StackT]);

onp_util(["/" | T], [A | [B | StackT]]) ->
  onp_util(T, [B / A | StackT]);

onp_util(["sqrt" | T], [A | StackT]) ->
  onp_util(T, [math:sqrt(A) | StackT]);

onp_util(["pow" | T], [A | [B | StackT]]) ->
  onp_util(T, [math:pow(B, A)| StackT]);

onp_util(["sin" | T], [A | StackT]) ->
  onp_util(T, [math:sin(A) | StackT]);

onp_util(["cos" | T], [A | StackT]) ->
  onp_util(T, [math:cos(A) | StackT]);

onp_util(["tan" | T], [A | StackT]) ->
  onp_util(T, [math:tan(A) | StackT]);

onp_util(["atan" | T], [A | StackT]) ->
  onp_util(T, [math:atan(A) | StackT]);

onp_util([Number | T], Stack) ->
  try
    onp_util(T, [list_to_float(Number) | Stack])
  catch
    error: _ -> onp_util(T, [list_to_integer(Number) | Stack])
  end.