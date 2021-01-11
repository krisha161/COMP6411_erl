%% @author patel
%% @doc @todo Add description to calling.


-module(calling).
-export([listen/1]).

listen(Sender)->
	receive
		{intro,S,R,Master,Sec} ->
			whereis(R) ! {reply,R,S,Master,Sec},
			timer:sleep(100),
			Master ! {intro,S,R,Master,Sec},
			listen(S);
		{reply,S,R,Master,Sec} ->
			Master ! {reply,R,S,Master,Sec},
			listen(S)
	after 5000 ->
		io:fwrite("\nProcess ~w has received no calls for 5 second, ending...",[Sender]),
		exit(done)
	end.



