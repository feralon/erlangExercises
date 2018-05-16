-module(misc).
-export([clear_status/1, prueba/1]).
-record(todo, {status=reminder,who=fernando,text}).


prueba([A|_] = S)->
io:format("~w~n",[A+1]),
  S.

clear_status(#todo{status=S, who=W} = R) ->
%% Inside this function S and W ar
%% values in the record
%%
%% R is the *entire* record
R#todo{status=finished}.
%% ...
