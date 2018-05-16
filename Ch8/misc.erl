-module(misc).
-vsn(12).
-compile(export_all).


-ifndef (prueba).
-define(name,rodrigo).
-else.
-define(name,nombreDeprueba).
-endif.

-define(fun1(A,B,C),{25 / 77,a,b,c}).
test(A,B,C)->{A,B,C}.
test([{C,D} = T|B],A)->{T,B}.
test(?name)->?fun1(a,b,c).
test()->?name.
