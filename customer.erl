
-module(customer).
-import(lists,[nth/2]).
-export([next/0,next2/0,pass/0,startc/0,customer/3]).


next() -> 
	spawn(fun() -> server1("Hello") end).

server1(Message) -> 
	io:fwrite(Message).



next2() ->
	 spawn(server,file,[4,3]).
	
pass() ->
	spawn(server,sayhi,(hi)).


last(N,List,Size)->
	receive
		
		{Message}-> List1=lists:append(List,[Message]),
					
					if N==Size->
			  			 Pid=spawn(money,listen,[]),
			  			 Pid!{l,List1};
					true->  N1=N+1 ,
						last(N1,List1,Size)
					end

	end.
	


customer(Name,Need1,Got1)->
	
	receive
		
		{Need,Got,List,Counter}->
		%	timer:sleep(1000),
			{ok, Banks} = file:consult("banks.txt"),
			Map = maps:from_list(Banks),
			N=maps:size(Map),
			Sel=rand:uniform(N),
			%io:fwrite("~w~n",[Sel]),
			Names= maps:keys(Map),
			Values=maps:values(Map),
			Bank= nth(Sel,Names),
			Status=lists:member(Bank, List),
		%	io:fwrite("~w",[Status]),
			Status1=not Status,
			if Status1->
			
			%	io:fwrite("In customer:~w ~w~n",[Name,Bank]),
				if Need>=50->
							X=rand:uniform(50),
			   				Bank ! {self(),X};

				true		->
							X=rand:uniform(Need),
							Bank ! {self(),X}
				end,
				io:fwrite("~w requested loan of ~w dollar(s) from ~w~n",[Name,X,Bank]),
			
				receive
								1->
								   Gotn=Got+X,
								   Needn=Need-X,
								   io:fwrite("~w granted loan of ~w dollar(s) to ~w ~n",[Bank,Gotn,Name]),
								   
								   if Needn==0->
										  Name ! {1,granted},
									  	  customer(Name,Needn,Gotn);
								   true->  
							  	   			Name ! {Needn,Gotn,List,Counter},
							  	   			customer(Name,Needn,Gotn)
								   end;  
								0->io:fwrite("~w rejected loan of ~w dollar(s) from ~w~n",[Bank,X,Name]),
								%	io:fwrite("~w List",[List]),
								    Listn=lists:append(List,[Bank]),
								    Counter1=Counter+1,
								%    io:fwrite("~w~n",[Listn]),
								%	io:fwrite("~w ~w",[Counter1,N]),
									if Counter1==N->
										   
										   Name ! {2,Got};
										  
										   
									true->
									%		io:fwrite("False"),
											Name ! {Need,Got,Listn,Counter1}
									%		io:fwrite("Sended")
											
											
											
									end,
								    Needn=Need,
								   	Gotn=Got,
									customer(Name,Needn,Gotn)
				end;
			
			true->
				Name!{Name,Got,List,Counter},
					customer(Name,Need,Got)
			
			
			end;
			
			
			
		{1,granted}->%io:fwrite("-------granted----~w~n",[Name]),
					
					customer(Name,Need1,Got1);
					
		{2,Got}->%io:fwrite("---------Got------~w~n",[Name]),
					customer(Name,Need1,Got);
		get->io:fwrite("~w got a total loan of ~w~n",[Name,Got1])
		 			
	end.
		
startall(N,Names,Values)->
	if N>0 ->List=[a,b],
		   		Name=nth(N,Names),
			   Value=nth(N,Values),
			   Name ! {Value,0,List,0},
				startall(N-1,Names,Values);
	true->io:fwrite("")
	end.	   


find2(N,Customer,Value)->
	
	if N==0->
		io:fwrite("");
 	true->
	
		Name= nth(N,Customer),
		Balance=nth(N,Value),
		PID = spawn(fun()-> customer(Name,Balance,0) end),			
		register(Name, PID),	
	%	io:fwrite("Registered:~w",[Name]),
		find2(N-1,Customer,Value)
	
	end.


find(N,Bank,Value)->
	if N==0->
		io:fwrite("");
 	true->
	
		Name= nth(N,Bank),
		Balance=nth(N,Value),
		PID = spawn(fun()-> bank:bank(Balance,Name) end),			
		register(Name, PID),	
	%	io:fwrite("Registered:~w",[Name]),
		find(N-1,Bank,Value)
	
	end.


displayc(N,Customer)->
	if N==0->
		   io:fwrite("");
	true->
		Name= nth(N,Customer),
		
		Name ! get,			
	%	io:fwrite("Registered:~w",[Name]),
		displayc(N-1,Customer)
	end.

displayb(N,Bank)->
	if N==0->
		   io:fwrite("");
	true->
		Name= nth(N,Bank),
		
		Name ! get,			
	%	io:fwrite("Registered:~w",[Name]),
		displayb(N-1,Bank)
	end.

startc()->
	{ok, Banks} = file:consult("banks.txt"),
%	io:fwrite("~p~n",[Banks]),
%	PID = spawn(fun server:loop/0),
	Map = maps:from_list(Banks),
	N=maps:size(Map),
	Names= maps:keys(Map),
	Values=maps:values(Map),
%	io:fwrite("Number:~w",[N]),
	
	
	
	{ok, Customer}=file:consult("customers.txt"),
	%% file:write(File, io_lib:fwrite("~w~n", [Message1])),
%	io:fwrite("~w",[Customer]),
	Mapc=maps:from_list(Customer),
	Namesc = maps:keys(Mapc),
	Valuesc = maps:values(Mapc),
	Nc=maps:size(Mapc),
	find2(Nc,Namesc,Valuesc),
	
	
	find(N,Names,Values),
%%	spawn(fun()-> find(N,Names) end),
	
%	Bank2= nth(2,Names),
	Cust1=nth(1,Namesc),
	Need=nth(1,Valuesc),
%	io:fwrite("Hey:~p~n",[registered()]),
	
%	List=[a],
%	Cust1 ! {Need,0,List,0}.
%	Bank2 ! {Bank2,ping}.

	startall(Nc,Namesc,Valuesc),
	timer:sleep(10000),
	io:fwrite("---------------~n"),
	displayc(Nc,Namesc),
	io:fwrite("---------------~n"),
	displayb(N,Names).

%%	PID ! {self(),Map},
%	receive
%		Message->io:fwrite("Got the message"),
%				 Message1=maps:from_list(Message),
%				Names=maps:keys(Message1), 
%				io:fwrite("~w~n",[nth(2,Names)])
%	end.

