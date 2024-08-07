-module(laba3).

-export([count_leaves/1]).
-export([make/4]).
-export([to_list/1]).
-export([is_queue/1]).
-export([empty/0]).
-export([insert/3]).
-export([extract_minimum/1]).
-export([insert2/4]).
-export([extract_minimum2/1]).
-export([insert3/3]).

-type tree() :: empty | {any(),tree(),tree()}.

-record(tree,{	value::any(),
				leftTree::tree(),
				rightTree::tree()
							}).

make(Value,[],[]) ->
	#tree{value = Value, leftTree = 'empty', rightTree = 'empty'};

make(Value,Left,Right) ->
	#tree{value = Value, leftTree = Left, rightTree = Right}.

make(Value,_,_,-1) -> make(Value,[],[]);
make(Value,Left,Right,Counter)->
	NLeft=make(Value-math:pow(2,Counter),Left,Right,Counter-1),
	NRight=make(Value+math:pow(2,Counter),Left,Right,Counter-1),
	make(Value,NLeft,NRight).

count_leaves(BinTree) -> count_leaves(BinTree,0).
count_leaves(BinTree,Any) ->
	if
		((BinTree#tree.leftTree == 'empty') and (BinTree#tree.rightTree == 'empty'))->
			Any+1;
		true->
			LAny = count_leaves(BinTree#tree.leftTree,Any),
			RAny = count_leaves(BinTree#tree.rightTree,Any),
			LAny+RAny
	end.
	
%%type queue — "очередь с приоритетом"

%% Функции
%is_queue(any) -> boolean
%empty() -> queue
%insert(Key, Value) -> queue
%extract_minimum() -> {Key, Value} | {'error'} 

%empty, insert — конструкторы
%is_queue — предикаты
%extract_minimum — селектор

%-type item() :: empty | {any(),any()}.
%-record(item, {value::any(), priority::any()}).

to_list(Queue) -> 
	New = lists:sort(Queue),
	only_values_from_queue_to_list(New, []).
	
only_values_from_queue_to_list([], NewList) 
	-> lists:reverse(NewList);
only_values_from_queue_to_list([H|T], NewList) ->
	{_, A2} = H, 
	only_values_from_queue_to_list(T, [A2|NewList]).

empty()-> [].

is_queue([]) -> 'ok';
is_queue([H|T]) ->
	true = is_list([H|T]),
	{A1, A2} = H,
	true = is_tuple(H),
	true = is_number(A1),
	true = is_number(A2),
	is_queue(T).
	
insert(Key, Value, Queue) -> 
	[{Key, Value}|Queue].
	
extract_minimum(Queue) -> 
	Min = extract_minimum(Queue, {'ok', 'super'}),
	lists:delete(Min, Queue).
extract_minimum([], Min) -> Min;
extract_minimum([H|T], Min) ->
	{A1, A2} = H,
	{B1, _} = Min,
	if 
		A1 < B1 -> extract_minimum(T, {A1, A2});
		true -> extract_minimum(T, Min)
	end.

insert2(Key, Value, [], List) -> lists:reverse(List)++[{Key,Value}];
insert2(Key, Value, [H|T],List) -> 
	{A1,_}=H,
	if	
		A1<Key ->insert2(Key, Value, T,[H|List]);
		true->
			lists:reverse(List)++[{Key,Value}]++[H|T]
	end.

insert3(Key, Value, List)->
	lists:sort(List++[{Key,Value}]).

extract_minimum2([_|T]) -> 
	T.