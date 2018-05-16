-module(exercises).
-export([map_search_pred/2,map_length/1]).


map_search_pred(Map, Pred)->map_search_pred(Map,Pred,maps:keys(Map)).

map_search_pred(Map,Pred,[Key|B])->Val = maps:get(Key,Map),
case Pred(Val) of
  true -> {Key,Val};
  false -> map_search_pred(Map,Pred,B)
end;
map_search_pred(_,_,[])->false.

map_length(Map) when is_map(Map) -> list_length(maps:keys(Map)).

list_length([_|List]) -> 1 + list_length(List);
list_length([])->0.
