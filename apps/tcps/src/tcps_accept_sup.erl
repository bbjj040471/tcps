%%%-------------------------------------------------------------------
%%% @author hebaoliang
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 五月 2018 上午12:31
%%%-------------------------------------------------------------------
-module(tcps_accept_sup).
-author("hebaoliang").

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link(Num :: integer()) ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link({Num, LSocket}) ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, [{Num, LSocket}]).


%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, {SupFlags :: {RestartStrategy :: supervisor:strategy(),
    MaxR :: non_neg_integer(), MaxT :: non_neg_integer()},
    [ChildSpec :: supervisor:child_spec()]
  }} |
  ignore |
  {error, Reason :: term()}).
init([{Num, LSocket}]) ->
  RestartStrategy = one_for_one,
  MaxRestarts = 1000,
  MaxSecondsBetweenRestarts = 3600,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = permanent,
  Shutdown = 1000,
  Type = worker,

  AChilds = [{list_to_atom("tcps_accept_" ++ integer_to_list(N)), {'tcps_accept', start_link, [{sock, LSocket}]},
    Restart, Shutdown, Type, ['tcps_accept']} || N <- lists:seq(1, Num)],

  {ok, {SupFlags, AChilds}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
