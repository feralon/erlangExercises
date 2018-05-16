-module(test2).
-export([test/1]).


-spec test(test1:coche())-> string().

test(Coche)->test1:ver_detalles(Coche).
