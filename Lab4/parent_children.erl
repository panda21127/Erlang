-module(parent_children).
-export([start/1]).
-compile(export_all).

start_child(Pid)->
	spawn(parent_children,child,[Pid]).

start_child(Pid,N)->
	start_child(Pid,N,[]).

start_child(_,0,List)->List;
start_child(FPid,N,List)->
	Pid = start_child(FPid),
	start_child(FPid,N-1,[Pid | List]).

send_child([],_,_,_)->'ok';
send_child([H|_],Message,Listchild,0)->H ! {'work',Message,Listchild};
send_child([_|T],Message,Listchild,N)->
	send_child(T,Message,Listchild,N-1).

stop([])->'ok';
stop([H|T])->
	H ! {'finish'},
	stop(T).

start(N)->
	Pid = spawn(parent_children,main,[[]]),
	Pid ! {'send','Finally',N}.

main(ListCheck)->
	receive
		{'finish'}->
			io:format("FINISH~n"),
			stop(ListCheck),
			exit(self(),kill);
		{'send',Message,N}->
			Listchild = start_child(self(),N),
			send_child(Listchild,Message,Listchild,2),
			main(Listchild);
		{'send_again',Message}->
			send_child(ListCheck,Message,ListCheck,3),
			main(ListCheck);
		{'get',Message,PID}->
			io:format("~w~n",[ListCheck]),
			io:format("Get ~w  from  ~w~n",[Message,PID]),
			self() ! {'finish'},
			main(ListCheck)
	end.
child(Pid)->
	receive
		{'work',Message,Listchild}->
			io:format("Hello is ~w  ~w  ~n",[self(),Message]),
			Pid ! {'get',Message,self()},
			child(Pid);
		{'finish'}->
			io:format("finish  ~w~n",[self()]),
			exit(self(),kill)
	end.