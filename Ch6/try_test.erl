-module(try_test).
-export([demo1/0]).

generate_exception(1) -> {polite,detailed};
generate_exception(2) -> throw({polite,detailed});
generate_exception(3) -> exit({polite,detailed});
generate_exception(4) -> {'EXIT', {polite,detailed}};
generate_exception(5) -> error({polite,detailed}).

demo1() ->
[catch(catcher(I)) || I <- [1,2,3,4,5]].

catcher(N) ->
try generate_exception(N) of
Val -> {N, normal, Val}
catch
throw:X -> {N, caught, thrown, X};
exit:X -> {N, caught, exited, X};
error:X -> {N, caught, error, erlang:get_stacktrace()}
end.
