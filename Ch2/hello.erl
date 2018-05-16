
-module(hello).
-export([start/0]).
start() ->
io:format( "Hola Romero~n"),
prueba().
prueba() ->
  io:format( "Funci¨®n de prueba~n").
