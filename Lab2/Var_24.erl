-module(var_24).

-export([min_positive_number / 1]).
-export([zipwith / 3]).
-export([iterate_map / 3]).
-export([for / 4]).
-export([diff / 2]).
-export([sortBy / 2]).
-export([comparator / 2]).

min_positive_number([Head | Tail]) ->
    min_positive_number([Head | Tail], 99999)
.
min_positive_number([Head | Tail], Old_number) ->
    if 
        is_number(Head) and (Head > 0) and (Head < Old_number) ->
            min_positive_number(Tail, Head);
        true ->
            min_positive_number(Tail, Old_number)
    end;
min_positive_number([], Old_number) ->
    if
        Old_number /= 99999 ->
            Old_number;
        true ->
            error("There is no positive numers")
    end
.

zipwith(_Fun, [], [], Result) -> Result;
zipwith(Fun, [Head1 | Tail1], [Head2 | Tail2], New_list) -> 
    Result = Fun(Head1, Head2),
    zipwith(Fun, Tail1, Tail2, [New_list | Result])
.
zipwith(Fun, List1, List2) -> 
    if
        length(List1) /= length(List2) -> error("Lists must have the same length");
        true -> 
            zipwith(Fun, List1, List2, [])
    end
.

iterate_map(F, X0, N) ->
    iterate_map(F, X0, N, [])
.
iterate_map(F, X0, N, Answer) ->
    if 
        N > 0 -> 
            iterate_map(F, F(X0), N - 1, [F(X0) | Answer]);
        true -> 
            lists:reverse(Answer)
    end
.

diff(F, Epsilon) -> 
    fun(X) ->
        (F(X + Epsilon) - F(X - Epsilon)) / (2 * Epsilon)
    end
.

for(Start, Expression, Step, Body) ->
    case Expression(Start) of 
        false -> ok;
        true -> 
            Result = Body(Start),
            io:format("Calculated: ~p~n", [Result]),
            for(Step(Start), Expression, Step, Body)            
    end
.    

comparator(X, Y) ->
    if
        X < Y -> 'less';
        X == Y -> 'equal';
        X > Y -> 'greater';
        true -> error("Invalid parametres to comparing")
    end
.

sortBy(_, []) -> [];
sortBy(Comparator, List) ->
    [Head | Tail] = List,
    sortBy(Comparator, [X || X <- Tail, (Comparator(X, Head) == 'less') or (Comparator(X, Head) == 'equal')]) ++
    [Head] ++
    sortBy(Comparator, [X || X <- Tail, Comparator(X, Head) == 'greater'])
.
