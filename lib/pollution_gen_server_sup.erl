%%%-------------------------------------------------------------------
%%% @author jan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Apr 2019 18:13
%%%-------------------------------------------------------------------
-module(pollution_gen_server_sup).
-author("jan").
-behavior(supervisor).

%% API
-compile(export_all).

start() ->
  start_link(nothing).

start_link(_) ->
  ets:new(table, [set, named_table, public]),
  ets:insert(table, pollution:createMonitor()),
  supervisor:start_link(
    {local, server_sup},
    ?MODULE, table
  ).

init(InitialValue) ->
  {ok, {
    {one_for_all, 10, 3},
    [ {serverPollution, {pollution_gen_server, start_link, [InitialValue]},
      permanent, brutal_kill, worker,
      [pollution_gen_server]}
    ]}
  }.



