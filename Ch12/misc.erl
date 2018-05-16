-module(misc).
-compile(export_all).


flush_buffer() ->
  receive
    _Any ->
      flush_buffer()
  after 0 ->
        true
      end.
    
sleep(A)-> receive after A ->ok end.
