%%%-------------------------------------------------------------------
%% @doc tcps top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(tcps_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_child/2]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

-define(CHILD(Mod, Type), {Mod, {Mod, start_link, []},
    permanent, 5000, Type, [Mod]}).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(Mod, Type)->
    supervisor:start_child(?MODULE, ?CHILD(Mod, Type)).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {one_for_one, 1000, 5000}, []} }.

%%====================================================================
%% Internal functions
%%====================================================================
