-module(lib_misc).
-export([qsort/1,pythag/1,perms/1,prueba/1,filter/2,filter2/2]).

qsort([]) -> [];
qsort([Pivot|T]) ->
qsort([X || X <- T, X < Pivot])
++ [Pivot] ++
qsort([X || X <- T, X >= Pivot]).

pythag(N) ->
[ {A,B,C} ||
A <- lists:seq(1,N),
B <- lists:seq(1,N),
C <- lists:seq(1,N),
A+B+C =< N,
A*A+B*B =:= C*C
].

perms([]) -> [[]];
perms(L) -> [[H|T] || H <- L, T <- perms(L--[H])].

filter(F,[A|B]) -> C = F(A),
if
  C =:= true ->  [A|filter(F,B)];
  true -> filter(F,B)
end;
filter(_,[])->[].

filter2(F,[A|B]) ->
  case F(A) of
    true -> [A|filter(F,B)];
    false -> filter(F,B)
  end;
filter2(_,[])->[].

prueba(X) when X < 5 orelse X =:= 3 -> ok.
