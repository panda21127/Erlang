-module(parent_children).
-export([start/1,send_to_child/3,stop/1,main/0,par_filter/3]).
-compile(export_all).

start_children()->
	spawn(parent_children, children,[]).
start_parent()->
	spawn(parent_children, parent,[]).

start(N)->
	Pid = start_parent(),
	List = creatChildren(N,[]),
	[Pid,List].
	
creatChildren(0,List)->List;
creatChildren(N,List)->
	Pid = start_children(),
	creatChildren(N-1,[Pid|List]).

search(1,[H|_])->H;
search(I,[_|T])->
	search(I-1,T).

send_to_child(I, Msg,List)->
	[H,T]=List,
	IPid=search(I,T),
	H ! {'task',Msg,IPid}.
stop([H,T])-> H ! {'die',T}.


children()->
	receive
		{'stop'}->
			io:format("Hi! I am stop~n");
		{'die'}->
			io:format("Hi! I am child ~w and I am die now~n",[self()]),
			'error';
		{'work',Msg}-> 
			io:format("Hi!~w get message: ~w~n",[self(),Msg]),
			children()
	end.
parent()->
	receive	
		{'die',List}->
			send_children_to_die(List),
			io:format("Hi! I am father and I am die now ~n");
		{'die',I,List}-> 
			IPid = search(I,List),
			io:format("Hi! I am father and ~w you are die for me ~n",[IPid]),
			IPid ! {'die'},
			Nlist = List--[IPid],
			NPid = start_children(),
			io:format("Hi! I am father and ~w you are new child for me ~n",[NPid]),
			[NPid|Nlist];
		{'task',Msg,IPid}-> 
			io:format("Hi!Children is ~w~n",[IPid]),
			IPid ! {'work',Msg}
	end,
	parent().
	
send_children_to_die([])->'ok';
send_children_to_die([H|T])->
	H ! {'die'},
	send_children_to_die(T).
	
main()->
	List=start(6),
	[H,T]=List,
	send_to_child(3, 'Hi',List),
	Somt = H!{'die',2,T},
	io:format("~w~n",[Somt]),
	stop(List).
	