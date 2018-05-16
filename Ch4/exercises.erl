-module(exercises).
-export([tuple_to_list/1,my_time_func/1]).

tuple_to_list(Tupla)->ttl(Tupla,1,tuple_size(Tupla)).

ttl(_,Cur,End) when Cur > End -> [];
ttl(T,Cur,End)->[element(Cur,T)|ttl(T,Cur +1,End)].

my_time_func(F) -> {_,_,S1} = time(), F(),{_,_,S2} = time(), S2 - S1.
