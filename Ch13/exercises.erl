-module(exercises).
-compile(export_all).
%-export([my_spawn/3,my_spawn2/3,my_spawn3/4,create_process4/4,
        %spawn_processes5/1,test/0,spawn_processes5/1,spawn_processes6/1]).

my_spawn(Mod,Func,Args)->
spawn(fun()->
{Pid,Ref} = spawn_monitor(Mod,Func,Args),
  T1 = os:system_time(),
  io:format("~p~n",[Pid]),
  receive
    {'DOWN',Ref,process,Pid,Why}->
      T2 = os:system_time(),
      io:format("El proceso con Pid ~p ha muerto por: ~p~nDuracion ~p segs ~n"
      ,[Pid,Why,(T2-T1) div 1000000])
    end end),ok.

my_spawn2(Mod,Func,Args)->
  Pid = spawn(Mod,Func,Args),
  misc:on_exit(Pid,fun(Why,T1)->
    T2 = os:system_time(),
    io:format("El proceso con Pid ~p ha muerto por: ~p~nDuracion ~p segs ~n"
    ,[Pid,Why,(T2-T1) div 1000000]) end,

    os:system_time()), Pid.

my_spawn3(Mod,Func,Args,Secs)->
  PidE = self(),
  spawn(fun()->
  case catch spawn_monitor(Mod,Func,Args) of
    {Pid,Ref} when is_pid(Pid) ->
      PidE ! Pid,
        T1 = os:system_time(),
        receive
          {'DOWN',Ref,process,Pid,Why}->
            T2 = os:system_time(),
            io:format("El proceso con Pid ~p ha muerto por: ~p~nDuracion ~p segs ~n"
            ,[Pid,Why,(T2-T1) div 1000000])
        after Secs ->io:format
          ("El proceso con Pid ~p ha muerto por tiempo(~p segs)~n",[Pid,Secs/1000]),
          exit(Pid,timeout)
        end;
    {'EXIT',Error} -> PidE ! Error,exit(Error)
  end end),
    receive
      X when is_pid(X)-> X;
      X->error(X)
      after 1000 -> exit(timeout)
    end.

create_process4(Mod,Func,Args,Name)->
  case whereis(register4) of
    undefined -> register(register4, spawn(fun()->register4() end));
    X when is_pid(X) -> ok;
    _ -> error("undefined error")
  end,
  spawn(fun()->
  case catch spawn_monitor(Mod,Func,Args) of
    {Pid,Ref} when is_pid(Pid) -> register4 ! {self(), Name, Pid} ,
    PidReg = whereis(register4),
    receive
      {PidReg,Pid} when is_pid(Pid)-> io:format("Registrado Correctamente ~n");
      {PidReg,_} -> io:format("Error en el registro, cuidado con el nombre ~n"),
      exit("Error al registrar, cuidado con el nombre")
    end,
    wait4({Pid,Ref,Mod,Func,Args,Name});
    {'EXIT',Error} ->Error %PidE ! Error,error(Error)
  end end).

wait4({Pid,Ref,Mod,Func,Args,Name} = Tuple)->
  receive
    {'DOWN',Ref,process,Pid,Why}->
      io:format("El proceso con Pid ~p ha muerto por: ~p~n y se resucitara~n"
      ,[Pid,Why]),create_process4(Mod,Func,Args,Name)
  after 5000 ->io:format
    ("Im Still running ~n"),wait4(Tuple)
  end.

register4()->
  receive
    {Return,Name,Pid} when is_pid(Return), is_pid(Pid), is_atom(Name) ->
    case catch register(Name,Pid) of
      true -> Return ! {self(),Pid};
      X -> Return ! {self(),{error,X}}
    end;
     _ -> ignored
  end, register4().


-spec spawn_processes5([fun(() -> pid()),...])->ok |error .
spawn_processes5(Lista)->spawn (fun()->wait5([{spawn_monitor(X),X} || X<-Lista])
end),ok.

wait5(L)->
  receive
    {'DOWN',Ref,process,Pid,Why} ->{_,{_,F},Ln} =lists:keytake({Pid,Ref},1,L),
    %io:format("Lista de procesos restante ~p~n",[Ln]),
    %io:format("Respuesta = ~p~n",[{F,Ln}]),
    wait5([{spawn_monitor(F),F}|Ln]);
    _ -> unexpected,wait5(L)
  end.

-spec spawn_processes6([fun(() -> pid()),...])->ok |error .

spawn_processes6(Lista)->spawn(fun()->
  wait6([{spawn_monitor(X),X} || X<-Lista]) end).

restart_processes6(Lista)->[{spawn_monitor(X),X} || {_,X}<-Lista].

remove_processes6([{{Pid,Ref},Fun}|Resto])->demonitor(Ref),exit(Pid,restarted),
                  remove_processes6(Resto);
remove_processes6([])->ok.

wait6(L)->
  receive
    {'DOWN',Ref,process,Pid,_} ->
      remove_processes6(lists:keydelete({Pid,Ref},1,L)),
      wait6(restart_processes6(L))
  end.

test()->
  receive
    final->ok
  %after 5000 -> exit(petene)
  end.

loop()->
  receive
    _->ok,loop()
  end.

funt()->r12 ! final, receive after 1 -> ok end, funt().
