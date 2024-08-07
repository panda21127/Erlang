-module(Var_17).
-export([start/0,ring/2,p/0]).
-export([info/1]).

%f().
%Fun = fun() -> receive after infinity -> ok end end.
%Pid = spawn(Fun).
%i().
%c(lab4).
%Pid=lab4:start().
%Pid ! {self(),"Hello from shell"}.
%flush().
%lab4:info(pid(0,84,0)).

info(Pid) ->  
	Spec = [registered_name, initial_call, links],
	case process_info(Pid, Spec) of
		undefined ->
			undefined;
		Result ->
			[{pid, Pid}|Result]
	end.


start() ->
  spawn(Var_17, p, []).
 
p() ->
	receive	
		{_,Num,0,_,_}->
			io:format("Hi! I am ~w    ~w~n",[self(),Num]),
			io:format("End~n");
		{FutureProc,Num,M,[],[H|T]}->
			FutureProc ! {H,Num+1,M-1,T,[H|T]},
			io:format("Hi! I am ~w    ~w~n",[self(),Num]);
		{FutureProc,Num,M,[H|T],List} ->
			FutureProc ! {H,Num+1,M,T,List},
			io:format("Hi! I am ~w    ~w~n",[self(),Num])
	end,
	p().

ring(N,M)->ring(N,M,[]).

ring(1,M,[H|T])->
	Pid = start(),
	Pid ! {H,1,M,T,([Pid]++[H|T])},
	"ok";
ring(N,M,List)->
	Pid = start(),
	ring(N-1,M,[Pid|List]),
	"ok".


