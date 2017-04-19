-module(my_handler).

-export([init/3]).
-export([content_types_provided/2]).
-export([get_html/2]).

init(_, _Req, _Opts) ->
	{upgrade, protocol, cowboy_rest}.

content_types_provided(Req, State) ->
	{[{{<<"text">>, <<"html">>, '*'}, get_html}], Req, State}.

get_html(Req, State) ->
  {ok, C} = epgsqla:start_link(),
  Ref = epgsqla:connect(C, "localhost", "postgres", "postgres", [{database, "postgres"}]),
    receive
      {C, Ref, connected} ->
        io:format("connected ~p", [C]);
      {C, Ref, Error = {error, _}} ->
        io:format("error is ~p", [Error])
    end,
  
  {Query, Req1} = cowboy_req:qs(Req),
  lager:log(info, [], " query string value is : ~s", [Query]),
  {Mail, Req2} = cowboy_req:qs_val(<<"mailid">>, Req1),
  lager:log(info, [], " id is : ~s", [Mail]),
  {Pass, Req3} = cowboy_req:qs_val(<<"password">>, Req2),
  lager:log(info, [], " password is : ~s", [Pass]),
  SelectRes = epgsql:equery(C, "insert into login values($1,$2)", [Mail, Pass]),
   lager:log(info, [], " result is : ~p", [SelectRes]),
  Body = <<"<html><body>This is REST!</body></html>">>,
  {Body, Req3, State}.