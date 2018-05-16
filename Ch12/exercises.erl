-module(exercises).
-compile(export_all).



start(AnAtom,Fun)->
 Name = eXz32aaS1,
 Pid = spawn(fun()->receive cancel->ok end end),
 try register(Name,Pid) of
  _ ->catch register(AnAtom,spawn(Fun)), Pid ! cancel,ok
 catch
  error:_ -> Pid ! cancel,exit("Ya existe otro proceso registrandose")
end.
