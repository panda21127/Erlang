-module(par_filter).
-export([par_filter/3]).

par_filter(F, List, _)-> lists:filter(F, List).