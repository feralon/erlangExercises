-module(myfile).
-import(file,[read_file/1]).
-export([read/1]).

read(File)->
  case read_file(File) of
    {ok,A}->A;
    {error,A}->throw(A)
  end.
