-module(geometry_server).
-compile(export_all).

start()->spawn(fun main/0).

main()->
  receive
    {S,rectangle,B,H}->S ! (B * H), main();
    {S,none}->io:format("recibido~n"),S ! none_ok, main()
  end.
