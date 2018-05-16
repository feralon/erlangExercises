-module(math_functions).
-export([even/1, odd/1,filter/2,filter2/2,split/1,splitRancio/1]).

even(X) when X rem 2 =:= 0 -> true;
even(_) -> false.

odd(X)-> not even(X).

filter(F, L) -> [X||X<-L,F(X)=:=true].

filter2(F,[A|B]) ->
  case F(A) of
    true -> [A|filter2(F,B)];
    false -> filter2(F,B)
  end;
filter2(_,[])-> [].

split(L)->split2(L,[],[]).

splitRancio(L)-> {[X||X<-L,odd(X)],[X||X<-L,even(X)]}.

split2([A|B],Odds,Evens)->
  case odd(A) of
    true -> split2(B,[A|Odds],Evens);
    false -> split2(B,Odds,[A|Evens])
  end;
split2([],Odds,Evens)->{odds,Odds,evens,Evens}.
