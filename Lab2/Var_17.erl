-module(var_17).

-export([sum_neg_squares/1]).
-export([dropwhile/2]).
-export([antimap/2]).
-export([solve/4]).
-export([for/4]).
-export([sortBy/2]).
-export([comparator/2]).

sum_neg_squares([]) -> 0;
sum_neg_squares(List) -> sum_neg_squares(List, 0).
sum_neg_squares([], Sum) -> Sum;
sum_neg_squares([Head | Tail], Sum)->
	if 
		Head < 0 -> 
		sum_neg_squares(Tail, Sum + math:pow(Head, 2));
		true -> sum_neg_squares(Tail, Sum)
	end.
% lab2:sum_neg_squares([-3, a, false, -3, 1]).
	
dropwhile(_, []) -> [];
dropwhile(Pred, [H|T]) -> 
	case Pred(H) of
		true -> dropwhile(Pred,T);
		false -> [H|T]
	end.
% lab2:dropwhile(fun(X) -> X < 10 end, [1,3,9,11,6]).
	
antimap([], _) -> [];
antimap(ListF, X) -> antimap(ListF, X, []).
antimap([], _, List) -> lists:reverse(List);
antimap([H|T], X, List) -> 
	antimap(T, X, [H(X)|List]).
% lab2:antimap([fun(X) -> X + 2 end, fun(X) -> 2*X*3 end], 4).

solve(Fun, A, B, 0) -> solve(Fun, A, B, 0.001);
solve(Fun, A, B, Eps) -> 
	C=(A+B)/2,
	%io:format("~w~n", [B-C]),
	AAA = Fun(A),
	BBB = Fun(B),
	CCC = Fun(C),
	if 
		(B - A) / 2 < Eps -> C;
		(AAA =< 0) and (0 =< CCC) -> 
			solve(Fun, A, C, Eps);
		(CCC =< 0) and (0 =< BBB) ->
			solve(Fun, C, B, Eps);
		true-> []
	end.
% lab2:solve(fun(X) -> X*X - 2 end, 0, 2, 0.001).


for(I, Cond, Step, Body)-> 
	case Cond(I) of
		true->
			io:format("~w~n",[Body(I)]),
			for(Step(I), Cond, Step, Body);
		false-> io:format("END~n")
	end.
%lab2:for(0,fun(I)-> I < 10 end,fun(I)-> I + 1 end,fun(I)-> I*2 end).

comparator(X,Y)->
	if
		X<Y -> 'less';
		X>Y -> 'greater';
		X==Y -> 'equal';
		true->[]
	end.
merge(_,[],[Head2|Tail2])-> [Head2|Tail2];
merge(_,[Head1|Tail1],[])-> [Head1|Tail1];
merge(Comparator,[Head1|Tail1],[Head2|Tail2])->
	case Comparator(Head1,Head2) of
		'less'-> [Head1 | merge(Comparator,Tail1,[Head2|Tail2])];
		'greater'->[Head2 | merge(Comparator,[Head1|Tail1],Tail2)];
		'equal'->[Head1 | merge(Comparator,Tail1,[Head2|Tail2])]
	end.


sortBy(_, [X])->[X];
sortBy(Comparator, List)->
	%io:format("~w~n",[Comparator(1,0)]),
	Length=round(length(List)/2),
	Str1=string:slice(List, 0, Length),
	Str2=string:slice(List, Length),
	%io:format("~w~n",[Str1]),
	%io:format("~w~n~n",[Str2]),
	NewStr1=sortBy(Comparator,Str1),
	NewStr2=sortBy(Comparator,Str2),
	%io:format("~w~n~n",[merge(Comparator,NewStr1,NewStr2)]),
	merge(Comparator,NewStr1,NewStr2).

%lab2:sortBy(fun lab2:comparator/2,[6,5,3,1,8,7,2,4]).