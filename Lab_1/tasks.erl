-module(tasks). % Вариант 17

-export([ball_volume/1 , from_to/2, delta/1, int_to_binary/1, rle_encode/1]).

-import(math,[pi/0]).

ball_volume(R) -> 4/3* pi() *R. % Task_1

from_to(N, M) when N == M -> 
   io:format("~w~n", [M]);
                                % Task_2
from_to(N, M) when N < M -> 
    io:format("~w~n", [M]),
    from_to(N, M-1).

delta([]) -> 0;
delta(List) -> 
    delta(List, [], 0).
delta([], List_New, Previous) ->lists:reverse(List_New); 
delta([Head|Tail], List_New, Previous) ->          % Task_3
    NewProduct = Head-Previous,
    io:format("~w~n", [NewProduct]),
    delta(Tail,[NewProduct|List_New],Head).


int_to_binary(N) when N <0 ->
     String = binary_to_list(integer_to_binary(5,2)),
     string:join(["-",String],"");                 % Task_4
int_to_binary(N) when N >= 0->
     integer_to_binary(5,2).




rle_encode([]) -> 0;
rle_encode(List) -> rle_encode(List, [], 0).
rle_encode([], Symbol, N) -> 0;
rle_encode([Head | Tail], Symbol, N) ->
     if 
        N>-1 ->
        io:format("~w~n",[is_binary(Symbol)]),
        io:format("~w~n",[is_atom(Symbol)]),
        io:format("~w~n",[is_float(Symbol)]),
        io:format("~w~n",[is_integer(Symbol)]),
        io:format("~w~n~n",[is_list(Symbol)]),
        io:format("~w~n~n",[string:equal(Symbol, [Head])]),
        rle_encode(Tail, [Head], N+1);
     true ->
        if
            N==0 ->
                rle_encode(Tail, Head, 0); %string:join([String,",",Head],"")
            true->
                rle_encode(Tail, Head, 0) %string:join([String,",{",Head,",",N,"}"],"")
        end
     end.

