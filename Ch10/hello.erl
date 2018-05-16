-module(hello).
-compile(export_all).


start(P)-> io:format("Hello ~s ~n",[P]).
main([A])->start(atom_to_list(A)).
