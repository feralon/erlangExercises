-module(shop2).
-export([total/1]).
-import(shop, [cost/1]).

map(_,[])->[];
map(F,[A|B]) ->[F(A)|map(F,B)].

sum([])->0;
sum([A|B]) -> A + sum(B).


total(Lista) -> sum(map(fun({Nom,Num})->cost(Nom)*Num end,Lista)).
