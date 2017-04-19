-module(login_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
Dispatch = cowboy_router:compile([
		{'_', [
			{"/", cowboy_static, {priv_file, login, "login.html"}},
			{"/[my_handler]", my_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 100, [{port, 8089}], 
	[
		
		{env, [{dispatch, Dispatch}]}
		
		
	]),	
login_sup:start_link().

stop(_State) ->
	ok.
