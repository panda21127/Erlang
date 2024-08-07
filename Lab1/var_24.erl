-module(var_24).

%erl
%c(var_24).
%var_24:split([1, 2, 3, 4, 5, 6], 3).

-export([disc/3]).
-export([inits/1]).
-export([split/2]).
-export([binary_to_int/1]).
-export([sliding_average/2]).
-export([intersect/2]).
-export([is_date/3]).

disc(A, B, C) ->
	if 
		A == 0,
		B == 0 -> 0;
		true ->
		if 
			A == 0 -> 1;
			true -> 
			D = B*B - 4*A*C,
			case D of
			   D when D > 0 -> 2;
			   D when D =:= 0 -> 1;
			   _ -> 0
			end
		end
    end.

inits([]) -> [];
inits([_]) -> [];
inits([Head | Tail]) -> [Head | inits(Tail)].

split(List, N) when N >= 0 ->
    split(List, [], N).

split([], Base, _N) ->
    [lists:reverse(Base), []];
split(List, Base, 0) ->
    [lists:reverse(Base), List];
split([Head | Tail], Base, N) -> split(Tail, [Head | Base], N - 1).


binary_to_int([])-> [];
binary_to_int(List) -> 
    [Head | Tail] = List,
    if
        Head == '-' -> binary_to_integer(list_to_binary(Tail), 2);
        true -> binary_to_integer(list_to_binary(List), 2)
    end.	
	
sliding_average([], _) -> [];
sliding_average(List, WindowSize)->sliding_average(List, WindowSize,0,[]).
sliding_average([Head | Tail], WindowSize,0,FinishList)when length([Head | Tail])==WindowSize ->
	New_List=string:slice([Head | Tail],0,WindowSize),
	Count=lists:sum(New_List)/WindowSize,
	io:format("~w -> ~w~n",[New_List,Count]),
	lists:reverse([Count|FinishList]);
	
sliding_average([Head | Tail], WindowSize,0,FinishList)->
	New_List=string:slice([Head | Tail],0,WindowSize),
	Count=lists:sum(New_List)/WindowSize,
	io:format("~w -> ~w~n",[New_List,Count]),
	sliding_average(Tail, WindowSize,0,[Count|FinishList]).
	
intersect(List1, List2) ->
    (List1 -- (List1 -- List2)).



is_date(DayOfMonth, MonthOfYear, Year) -> 
    is_date(DayOfMonth, MonthOfYear, Year, 6).
is_date(0, MonthOfYear, Year,Day)->
	case MonthOfYear of
		MonthOfYear when MonthOfYear == 2;
						 MonthOfYear == 4;
						 MonthOfYear == 6;
						 MonthOfYear == 8;
						 MonthOfYear == 9;
						 MonthOfYear == 11;
						 MonthOfYear == 1 ->
			                is_date(31, MonthOfYear-1, Year,Day);
		MonthOfYear when MonthOfYear == 5;
						 MonthOfYear == 7;
						 MonthOfYear == 10;
						 MonthOfYear == 12 ->
			                is_date(30, MonthOfYear-1, Year,Day);
		MonthOfYear when MonthOfYear == 3->
			if
				(((Year rem 4) == 0) and ((Year rem 100) /= 0)) or ((Year rem 400) == 0)->
					is_date(29, MonthOfYear-1, Year,Day);
				true->
					is_date(28, MonthOfYear-1, Year,Day)
			end
		end
    ;

is_date(_, 0, Year, Day) -> 
    is_date(31, 12, Year-1,Day);

is_date(DayOfMonth, MonthOfYear, Year,8) ->
    is_date(DayOfMonth, MonthOfYear, Year,1);

is_date(1, 1, 2000, Day)->
	case Day of
		Day when Day == 1 -> io:format("Monday~n");
		Day when Day == 2 -> io:format("Tuesday~n");
		Day when Day == 3 -> io:format("Wednesday~n");
		Day when Day == 4 -> io:format("Thursday~n");
		Day when Day == 5 -> io:format("Friday~n");
		Day when Day == 6 -> io:format("Saturday~n");
		Day when Day == 7 -> io:format("Sunday~n")
	end
;
is_date(DayOfMonth, MonthOfYear, Year,Day) ->
    is_date(DayOfMonth - 1 , MonthOfYear, Year, Day+1).
	