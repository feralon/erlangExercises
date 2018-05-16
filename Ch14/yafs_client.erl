-module(yafs_client).
-compile(export_all).

connect(_Name,A,B,C,D,E)->
  lib_chan:connect(A,B,C,D,E).

connect(Name)->
  {ok,Pid}=lib_chan:connect("localhost",2233,fileserver,"qwerty",""),
  register(Name,Pid).

test(Name)->
  lib_chan:rpc(whereis(Name),{test}).

ls(Name)->
  lib_chan:rpc(whereis(Name),{ls}).

pwd(Name)->
  lib_chan:rpc(whereis(Name),{pwd}).

cd(Name,Directory)->
  lib_chan:rpc(whereis(Name),{cd,Directory}).

download(Name,FileName)->
  File = lib_chan:rpc(whereis(Name),{download,FileName}),
  file:write_file(FileName,File),
  {ok,downloaded}.

upload(Name,Filename)->
  {ok,Bin}=file:read_file(Filename),
  lib_chan:rpc(whereis(Name),{upload,Filename,Bin}),
  {ok,uploaded}.


set_download_path(Path)->file:set_cwd(Path).
