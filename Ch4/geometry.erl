-module(geometry).
-export([area/2,test/0]).

test() ->
  8 = area(inventado,5),
  3 = area(lista,[2,6,4]),
  testOk.

area(circulo,Radio)-> 3.14 * Radio * Radio;
area(inventado,Num)-> A = Num * 2, A - 2;
area(lista,[])->0;
area(lista,[_|B])->area(lista,B) + 1.
