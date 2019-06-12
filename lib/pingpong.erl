%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Apr 2019 13:07
%%%-------------------------------------------------------------------
-module(pingpong).
-author("jan").

%% API
-export([start/0, stop/0, play/1]).

start() ->
  register(ping, spawn(fun() -> pingfun()end)),
  register(pong, spawn(fun() -> pongfun()end)).

pingfun() ->
  receive
    0 -> ok;
    N ->
      io:format("ping ~p~n", [N]),
      pong ! (N-1)
  end.

pongfun() ->
  receive
    0 -> ok;
    N ->
      io:format("ping ~p~n", [N]),
      ping ! (N-1)
  end.

play(N) ->
  ping ! N.

stop() ->
  ping ! 0.
