-module(tcp_client).
-export([fetch/0]).

fetch() ->
    Host = "www.erlang.org",
    Port = 80,
    {ok, Socket} = gen_tcp:connect(Host, Port, [binary, {packet, 0}, {active, false}]),
    Request = "GET / HTTP/1.0\r\nHost: " ++ Host ++ "\r\nConnection: close\r\n\r\n",
    ok = gen_tcp:send(Socket, Request),
    Status = recv_all(Socket, []),
    gen_tcp:close(Socket),
    Status.

recv_all(Socket, Acc) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Bin} ->
            recv_all(Socket, [Bin | Acc]);
        {error, closed} ->
            iolist_to_binary(lists:reverse(Acc));
        {error, Reason} ->
            {error, Reason}
    end.

