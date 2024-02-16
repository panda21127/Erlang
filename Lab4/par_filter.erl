-module(par_filter).
-export([par_filter/3,slice_list/2]).
-compile(export_all).

%par_filter:par_filter(fun(X)-> X<5 end,[1,2,3,4,5,6,7,8,9,1110,9,4,9,23,9,4,9,4,9,2],{'sublist_size',2,'processes',2}).

start_children(Pid)->
    spawn(par_filter,children,[Pid]).
start_main(Fun,List)->
    spawn(par_filter,main,[self(),Fun,List]).

par_filter(Fun, List, Options) -> 
    Pid = start_main(Fun,List),
    Pid ! Options.

spawn_childrens(Pid,N)->spawn_childrens(Pid,N,[]).
spawn_childrens(_,0,List)->List;
spawn_childrens(FPid,N,List)->
    Pid=start_children(FPid),
    spawn_childrens(FPid,N-1,[Pid|List]).

slice_list(List,Sublist_size)->
    slice_list(List,Sublist_size,Sublist_size,[],[]).

slice_list([],_,_,TempList,NewList)->
    NList=lists:reverse(TempList),
    lists:reverse(([NList|NewList]));

slice_list([H|T],0,Start,TempList,NewList)->
    NList=lists:reverse(TempList),
    slice_list([H|T],Start,Start,[],[NList|NewList]);

slice_list([H|T],Sublist_size,Start,TempList,NewList)->
    slice_list(T,Sublist_size-1,Start,[H|TempList],NewList).


send_to_child(Fun,SliceList,ListChild)->
    LenghtSliceList = length(SliceList),
    LenghtListChild = length(ListChild),
    if 
        LenghtListChild<LenghtSliceList ->
            NNumber = LenghtSliceList div LenghtListChild,
            send_to_child(Fun,SliceList,NNumber,NNumber,ListChild,[]);
        true->
            send_to_child(Fun,SliceList,1,1,ListChild,[])
    end.

send_to_child(Fun,[H],_,_,[Head|_],List)->
    %io:format("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"),
    Head ! {'work',Fun,(lists:reverse([H|List]))};
send_to_child(Fun,[H|T],1,Start,[Head|Tail],List)->
    %io:format("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"),
    Head ! {'work',Fun,(lists:reverse([H|List]))},
    send_to_child(Fun,T,Start,Start,Tail,[]);
send_to_child(Fun,[H|T],Sublist_size,Start,ListChild,List)->
    %io:format("Hello ~w~n",[List]),
    %io:format("Hello ~w~n",[Sublist_size]),
    send_to_child(Fun,T,Sublist_size-1,Start,ListChild,[H|List]).



main(Pid,Fun,List)->
    receive
        {'sublist_size',Sublist_size,'processes',Processes,'timeout',Timeout}->
            io:format("Hello ~w~n",[List]),
            io:format("Sublist_size ~w~n",[Sublist_size]),
            io:format("Processes ~w~n",[Processes]),
            io:format("Timeout ~w~n",[Timeout]),
            ListChild = spawn_childrens(Pid,Processes),
            SliceList = slice_list(List,Sublist_size),
            io:format("Hello ~w~n",[ListChild]),
            io:format("Hello ~w~n",[SliceList]),
            send_to_child(Fun,SliceList,ListChild);

        {'sublist_size',Sublist_size,'processes',Processes}->
            self() ! {'sublist_size',Sublist_size,'processes',Processes,'timeout','infinity'};
        {'processes',Processes,'timeout',Timeout}->
            self() ! {'sublist_size',1,'processes',Processes,'timeout',Timeout};
        {'sublist_size',Sublist_size,'timeout',Timeout}->
            self() ! {'sublist_size',Sublist_size,'processes',string:length(List),'timeout',Timeout};
        
        {'sublist_size',Sublist_size}->
            self() ! {'sublist_size',Sublist_size,'processes',string:length(List),'timeout','infinity'};
        {'processes',Processes}->
            self() ! {'sublist_size',1,'processes',Processes,'timeout','infinity'};
        {'timeout',Timeout}->
            self() ! {'sublist_size',1,'processes',string:length(List),'timeout',Timeout};
        {'end',FList}->
            io:format("kizil~n"),
            io:format("Finaly List: ~w~n",[FList])
    end,
    main(Pid,Fun,List).

children(Pid)->
    receive
        {'die'}->
            io:format("kizil~n");
        {'work',Fun,List}->

            NewList = listerFilter(Fun,List),
            io:format("Child is ~w    ~w ~n",[self(),List]),
            io:format("Child is ~w    ~w ~n",[self(),NewList]), 
            c:i(),
            io:format("Father is ~w  ~n",[Pid]),
            Pid ! {'end',NewList}
    end.

listerFilter(Fun,List)->
    listerFilter(Fun,List,[]).
listerFilter(_,[],NList)-> lists:reverse(NList);
listerFilter(Fun,[H|T],NList)->
    NewList = lists:filter(Fun,H),
    listerFilter(Fun,T,[NewList|NList]).