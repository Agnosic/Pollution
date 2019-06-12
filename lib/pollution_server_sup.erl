%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Apr 2019 13:17
%%%-------------------------------------------------------------------
-module(pollution_server_sup).
-author("jan").

%% API
-export([start/0, init/0]).

start() ->
  spawn(?MODULE, init, []).

init() ->
  process_flag(trap_exit, true),
  loop().

loop() ->
  Pid = spawn(pollution_server, start, []),
  link(Pid),
  receive
    {'Exit', _, _} -> loop();
    stop -> ok
  end.

stop() ->
  ?MODULE ! stop.

