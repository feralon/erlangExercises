-module(analyzer).
%-compile(export_all).
-import(maps,[get/2,is_key/2,to_list/1]).
-author(fernando).
-vsn(1.0).
-export([readModulesCharged/0,unambiguous_find/0]).

-spec readModulesCharged()->Result when
Result::  ok | error.

readModulesCharged()->L = code:all_loaded(),
                  {Module,Number}= mostModuleFuncs(L,{null,0}),
                  {Na,Nu} = nOfExports(Module),
                  io:format("Module with most n of funs: ~w (~w funs)~n",[Module,Number]),
                  io:format("Fun more overloaded: ~w (~w times) ~n",[Na,Nu]).



mostModuleFuncs([{Mod,_}|B],{_,Num} = T)->
case numFunc(Mod) of
    X when X > Num -> mostModuleFuncs(B,{Mod,X});
    _ -> mostModuleFuncs(B,T)
end;
mostModuleFuncs([],T)->T.


numFunc(Module)->[_,{exports,Lista}|_] = Module:module_info(),
                numFunc(Lista,0).

numFunc([_|B],Num)->numFunc(B,Num + 1);
numFunc([],N)->N.

nOfExports(Module)->[_,{exports,Lista}|_] = Module:module_info(),
                    nOfExports(Lista,#{}).

nOfExports([{Name,_}|B],Dict)->
case is_key(Name,Dict) of
  true -> nOfExports(B,Dict#{Name:= (get(Name,Dict) + 1)});
  false-> nOfExports(B,Dict#{Name => 1})
end;
nOfExports([],Dict)->findMay(Dict).

findMay(Dict) when is_map(Dict) ->findMay(to_list(Dict),{0,0}).

findMay([Tu = {_,Num}|B],Tu2 = {_,NumM})->
  if
    Num > NumM ->findMay(B,Tu);
    true->findMay(B,Tu2)
  end;
findMay([],T)->T.

%Find unambiguous modules (charged)
-spec unambiguous_find() -> [any()].

unambiguous_find()-> L = code:all_loaded(),
                     search_modules(L,[]).

search_modules([{Module,_}|B],L) -> [_,{exports,Lista}|_] = Module:module_info(),
  New = search_functs(Lista,[]),
  Add = New -- L,
  Fin = L -- New,
  search_modules(B,Fin ++ Add);

search_modules([],L)->L.

search_functs([{Name,_}|B],O) ->
case lists:member(Name,O) of
  true -> search_functs(B,O);
  false -> search_functs(B,[Name|O])
end;

search_functs([],O)->O.
