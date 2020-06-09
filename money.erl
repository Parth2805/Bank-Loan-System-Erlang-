
-module(money).
-import(lists,[nth/2]).
-export([start/0]).





start()->
	spawn(customer,startc,[]).
