-module(lab3).

-export([count_leaves/1,make/4,list_maker_of_tree/1,split/2,is_subset/2,delete/2]).
%-export_type([tree/3]).

%rr("lab3.erl").
%f().
%c(lab3).
%Tree = #tree{value = 10, left = #tree{value=1,left=[]}, right = #tree{value=20}}.

-type tree() :: empty | {any(),tree(),tree()}.

-record(tree,{	value::any(),
				leftTree::tree(),
				rightTree::tree()
							}).


make(Value,[],[])->
	#tree{value = Value, leftTree = 'empty', rightTree = 'empty'};

make(Value,Left,Right)->
	#tree{value = Value, leftTree = Left, rightTree = Right}.

make(Value,Left,Right,-1)->make(Value,[],[]);
make(Value,Left,Right,Counter)->
	NLeft=make(Value-math:pow(2,Counter),Left,Right,Counter-1),
	NRight=make(Value+math:pow(2,Counter),Left,Right,Counter-1),
	make(Value,NLeft,NRight).

count_leaves(BinTree)->count_leaves(BinTree,0).
count_leaves(BinTree,Any)->
	if
		((BinTree#tree.leftTree == 'empty') and (BinTree#tree.rightTree == 'empty'))->
			Any+1;
		true->
			LAny = count_leaves(BinTree#tree.leftTree,Any),
			RAny = count_leaves(BinTree#tree.rightTree,Any),
			LAny+RAny
	end.
	
list_maker_of_tree(BinTree)->
	if
		((BinTree#tree.leftTree == 'empty') and (BinTree#tree.rightTree == 'empty'))->
			[BinTree#tree.value];
		true->
			LAny = list_maker_of_tree(BinTree#tree.leftTree),
			RAny = list_maker_of_tree(BinTree#tree.rightTree),
			LAny ++ [BinTree#tree.value] ++ RAny
	end.
	
list_finder_argument_and_return_two_list_please([Head|Tail],Any)->
	if
		Head == Any ->
			Tail;
		true ->
			list_finder_argument_and_return_two_list_please(Tail,Any)
	end.

create_tree_of_list([Head],_)->make(Head,[],[]);
create_tree_of_list([Head|Tail],Right)->
	NRight=create_tree_of_list(Tail,Right),
	make(Head,make([],[],[]),NRight).

split(BinTree,Any)->
	List = list_maker_of_tree(BinTree),
	IDAny = lists:keyfind(Any,1,List),
	io:format("~w~n",[IDAny]),
	RList = list_finder_argument_and_return_two_list_please(List,Any),
	LList = List -- RList,
	io:format("~w~n",[LList]),
	io:format("~w~n",[RList]),
	AAA = create_tree_of_list((lists:reverse(LList)),[]),
	BBB = create_tree_of_list(RList,[]),
	{AAA, BBB}.

%%type set — "множество"

%% Функции
%is_set(any) -> boolean — операция проверки, представляет ли произвольное значение "множество"
%has(Set, X) -> boolean — возвращает true если item есть в коллекции, иначе — false;
%empty_set() -> set — создание пустого "множества"
%add(Set, X) -> {'ok',set}|{'error',set} — добавляет элемент item в набор, возвращает set. Если пытаться добавить существующий, ничего не произойдет;
%clear() ->	set — очищает set;
%delete(Set, X) -> {'ok',set}|{'error',set} — удаляет item из множества, возвращает кортеж c 'ok', если он там был, иначе кортеж с 'error'.

%empty_set, add, clear, delete — конструкторы
%is_set и has — предикаты
%delete и add — селектор


is_subset(Set1,Set2)->
	List=(Set1--Set2),
	if
		List==[]->true;
		true->false
	end.

%% Реализация

is_set(Set)-> is_list(Set).
is_empty(Set) -> Set == [].

has(X, Set)->lists:member(X, Set).

add([], X) ->'ok';
add(Set, X) ->
	Y = has(X, Set),
	if 
		Y == true -> {'error', Set};
		true -> {'ok', [X |Set]}
	end.

delete(Set, X)->
	Y = has(X, Set),
	if 
		Y == true -> 
			NSet=lists:delete(X,Set),
			{'ok', NSet};
		true -> {'error', Set}
	end.

clear()->[].

%%Сложность O(n).