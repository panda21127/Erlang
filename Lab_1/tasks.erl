-module(tasks). % Вариант 17

-export([ball_volume/1 , from_to/2, delta/1, int_to_binary/1, rle_encode/1,intersect/2,is_date/3]).

-import(math,[pi/0,pow/2]).

ball_volume(R) -> 4/3* pi() * pow(R,3). % Task_1

from_to(N, M)->from_to(N, M,[]).      % Task_2
from_to(N, M,List) -> 
    if    
        N =< M ->
            from_to(N, M-1,[M|List]);
        true -> List
    end.

delta([]) -> 0;
delta(List) -> delta(List, [], 0).
delta([], List_New, Previous) ->lists:reverse(List_New); 
delta([Head|Tail], List_New, Previous) ->          % Task_3
    NewProduct = Head-Previous,
    %io:format("~w~n", [NewProduct]),
    delta(Tail,[NewProduct|List_New],Head).


int_to_binary(N) when N <0 ->
     String = binary_to_list(integer_to_binary(N,2)),
     string:join(["-",String],"");                 % Task_4
int_to_binary(N) when N >= 0->
     integer_to_binary(N,2).




rle_encode([]) -> 0;
rle_encode([Head | Tail]) -> rle_encode([Head | Tail], Head , [] , 0).
rle_encode([], Symbol,FinishList, N) -> 
    if
        N == 1 ->
            NewList= Symbol;
        true ->
            NewList= {Symbol,N}
    end,
    lists:reverse([NewList | FinishList]);
rle_encode([Head | Tail], Symbol, FinishList, N) ->
    if 
        Symbol == Head->
            rle_encode(Tail, Head,FinishList, N+1);
        true ->
            if
                N == 1 ->
                    NewList= Symbol,
                    rle_encode(Tail, Head,[NewList|FinishList], 1); %string:join([String,",",Head],"")
                true->
                    NewList= {Symbol,N},
                    rle_encode(Tail, Head,[NewList|FinishList], 1) %string:join([String,",{",Head,",",N,"}"],"")
            end
     end.



     intersect(List1, List2)-> (List1 -- (List1 -- List2)).  % Task_6



     is_date(DayOfMonth, MonthOfYear, Year)->is_date(DayOfMonth, MonthOfYear, Year,6).
     is_date(0, MonthOfYear, Year,Day)->
         case MonthOfYear of
             MonthOfYear when MonthOfYear == 2;
                              MonthOfYear == 4;
                              MonthOfYear == 6;
                              MonthOfYear == 8;
                              MonthOfYear == 9;
                              MonthOfYear == 11;
                              MonthOfYear == 1->
                 is_date(31, MonthOfYear-1, Year,Day);
             MonthOfYear when MonthOfYear == 5;
                              MonthOfYear == 7;
                              MonthOfYear == 10;
                              MonthOfYear == 12->
                 is_date(30, MonthOfYear-1, Year,Day);
             MonthOfYear when MonthOfYear == 3->
                 if
                     (((Year rem 4) == 0) and ((Year rem 100) /= 0)) or ((Year rem 400) == 0)->
                         is_date(29, MonthOfYear-1, Year,Day);
                     true->
                         is_date(28, MonthOfYear-1, Year,Day)
                 end                                                                                             % Task_7
             end;
     is_date(_, 0, Year,Day)->is_date(31, 12, Year-1,Day);
     is_date(DayOfMonth, MonthOfYear, Year,8)->is_date(DayOfMonth, MonthOfYear, Year,1);
     is_date(1, 1, 2000,Day)->
         case Day of
            Day when Day == 1 -> io:format("Понедельник~n");
		    Day when Day == 2 -> io:format("Вторник~n");
		    Day when Day == 3 -> io:format("Среда~n");
		    Day when Day == 4 -> io:format("Четверг~n");
		    Day when Day == 5 -> io:format("Пятница~n");
		    Day when Day == 6 -> io:format("Суббота~n");
		    Day when Day == 7 -> io:format("Воскресенье~n")
         end;
     is_date(DayOfMonth, MonthOfYear, Year,Day)-> is_date(DayOfMonth - 1 , MonthOfYear, Year,Day+1).
     
