%% @author patel
%% @doc @todo Add description to exchange.


-module(exchange).

-import(string,[substr/3]).
-import(lists,[delete/2,reverse/1]).
-export([start/0,listen1/0]).

start()->
	read_file().

print_main([],M1)-> io:fwrite(" ");
print_main(K,M1)->
	[H|T]=K,
	io:fwrite("\n  ~p : ~w",[H,maps:get(H,M1)]),
	print_main(T,M1).
	
get_ids([])-> io:fwrite(" ");
get_ids(K)->
	[H|T]=K,
	register(H,spawn(calling,listen,[H])),
	get_ids(T).

send_msgvalue(H,[],Master)-> io:fwrite(" ");
send_msgvalue(H,Lis,Master)->
	[Head|Tail]=Lis,
	Times=erlang:now(),
	{_,_,X}=Times,
	Sec=X,
	whereis(H)! {intro,H,Head,Master,Sec},
	send_msgvalue(H,Tail,Master).

send_msgkey([],M1,Master)-> io:fwrite(" ");
send_msgkey(K,M1,Master)->
	[H|T]=K,
	Lis=maps:get(H, M1),
	send_msgvalue(H,Lis,Master),
	send_msgkey(T,M1,Master).


		
listen1()->
	receive
		{intro,S,R,Master,Sec} ->
			io:fwrite("\n~p received intro message from ~p [~p]",[S,R,Sec]),
			listen1();
		{reply,S,R,Master,Sec} ->
			io:fwrite("\n~p received reply message from ~p[~p]",[R,S,Sec]),
			listen1()
	after 10000->
		io:fwrite("\nMaster has received no calls for 10 second, ending..."),
		exit(done)
	end.



read_file()->
	{ok,Words} = file:consult("calls"),
	M1 = maps:from_list(Words),
	Master=spawn(exchange,listen1,[]),
	io:fwrite("\n*calls to be made*"),
	K=maps:keys(M1),
	print_main(K,M1),
	K1=maps:keys(M1),
	get_ids(maps:keys(M1)),
	send_msgkey(K1,M1,Master).



	

	






