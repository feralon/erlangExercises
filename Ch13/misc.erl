-module(misc).
-compile(export_all).

on_exit(Pid, Fun, T1) ->
  spawn(fun() ->
    Ref = monitor(process, Pid),
    receive
      {'DOWN', Ref, process, Pid, Why} ->
        Fun(Why,T1)
      end
    end).

start(Fs) ->
    spawn(fun() ->
      [spawn_link(F) || F <- Fs],
      receive
        after
          infinity -> true
        end
      end).
