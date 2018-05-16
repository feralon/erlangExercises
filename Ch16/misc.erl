+-module(misc).
-compile(export_all).

unconsult(L,Filename)-> {ok,File} = file:open(Filename,[write]),
lists:foreach(fun(Elem)->io:fwrite(File,"~p.~n",[Elem]) end,L),
file:close(File).

newton(Xn,X,0)->{ok,{'sqr(X)',X},Xn};
newton(Xn,X,It)->Res = Xn - (((Xn*Xn) - X)/(2 * Xn)),
io:format("~p~n",[Res]),newton(Res,X,It -1).

-include_lib( "kernel/include/file.hrl" ).

file_size_and_type(File) ->
case file:read_file_info(File) of
{ok, Facts} ->
{Facts#file_info.type, Facts#file_info.size};
_ ->
error
end.

ls_l(Dir)->{ok,Files} = file:list_dir(Dir),
lists:map(fun property/1,Files).

property(File)-> case file:read_file_info(File) of
  {ok, Facts} -> {File,{links,Facts#file_info.links},
  {size,Facts#file_info.size}};
    _ ->error
  end.
