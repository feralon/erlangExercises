-module(test1).
-export([ver_coches/0,ver_detalles/1]).


-type coche()::{string(),integer()}.

-export_type([coche/0]).

-spec ver_coches()-> Lista_de_Coches:: [coche()].
ver_coches()->[{"Matricula1",0},{"Matricula2",1}].

-spec ver_detalles(coche())-> Detalles:: string().
ver_detalles({S,A})->[Str] = io_lib:format("~p",[A]),
  "Coche " ++ Str  ++ " con matricula " ++ S.
