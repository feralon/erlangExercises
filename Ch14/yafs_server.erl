-module(yafs_server).
-compile(export_all).

start()-> lib_chan:start_server(config1).

run(MM,_ArgC,_ArgS)->{ok,Dir}=file:get_cwd(),put(home,Dir),loop(MM).

loop(MM)->
  receive
    {chan, MM, {test}}->
      MM ! {send,test_completed},
      loop(MM);
    {chan, MM, {ls}}->
      MM ! {send,ls()},
      loop(MM);
    {chan, MM, {pwd}}->
      MM ! {send,pwd()},
      loop(MM);
    {chan, MM, {cd,Directory}}->
      MM ! {send,cd(Directory)},
      loop(MM);
    {chan, MM, {download,Filename}}->
      MM ! {send,download(Filename)},
      loop(MM);
    {chan, MM, {upload,Filename,Bin}}->
      MM ! {send,upload(Bin,Filename)},
      loop(MM)
  end.

pwd()->{ok,Dir}= file:get_cwd(),case get(home) of
   Dir -> "/";
  X -> Dir -- X
end.

ls()->{ok,Dir} = file:get_cwd(),{ok,Files} = file:list_dir_all(Dir),
  group_dirs(Files).

group_dirs([A|B])->case is_directory(A) of
  false -> [{A,file}|group_dirs(B)];
  true -> [{A,dir}|group_dirs(B)]
end;
group_dirs([])->[].

is_directory(File)-> case file:consult(File) of
  {error,eisdir} -> true;
  _ -> false
end.

cd(Directory)->{ok,Dir} = file:get_cwd(),{ok,Files} = file:list_dir_all(Dir),
case get(home) of
  Dir -> Lista = lists:filter(fun is_directory/1,Files);
  _-> Lista = [".."|lists:filter(fun is_directory/1,Files)]
  end, case lists:member(Directory,Lista) of
    true -> file:set_cwd(Directory),ok;
    false -> {error,directorio_no_encontrado}
  end.

download(Filename)->{ok,Bin}=file:read_file(Filename),Bin.

upload(Binary,Filename)->file:write_file(Filename,Binary),ok.
