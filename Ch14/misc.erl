-module(misc).
-compile(export_all).

daemon()-> receive X->io:format("~p~n",[X]),daemon()
end.
test()->?MODULE.
