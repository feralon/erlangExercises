-module(misc).
-compile(export_all).


-type status() :: on | off.

-spec test(A,B)->_ when
      A :: 0..4,
      B :: integer().

test(A,B) -> {A + B,b,B}.
test3(0)->1;
test3(N)->N * test3(N-1).
test2()->test3(22223).
