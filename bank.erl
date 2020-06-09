-module(bank).
-export([start/0,bank/2]).

start()->
	io:fwrite("~w",[registered()]).

bank(X,Name)->
	receive
		get->io:fwrite("~w left with ~w dollar(s)~n",[Name,X]);
		
		
		{PID,Need}->
			if X >= Need->
				   NewX=X-Need,
				%   io:fwrite("~w granted loan of ~w~n",[Name,Need]),
				   PID ! 1,
			   	   bank(NewX,Name);
			true->
					PID ! 0,
					bank(X,Name)
			end
	
	end.