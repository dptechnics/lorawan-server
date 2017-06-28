-module(lorawan_application_http).
-behaviour(lorawan_application).

-export([init/1, handle_join/3, handle_rx/4]).

-include_lib("lorawan_server_api/include/lorawan_application.hrl").

% The init/1 will be called upon server initialization. It shall return either ok or a tuple  {ok, PathsList} to define application specific URIs.
init(_App) ->
    ok.

%The handle_join/3 will be called when a new node joins the network. Accept all devices.
handle_join(_Gateway, _Device, _Link) ->
ok.

%The handle_rx/4 will be called when data is received.
handle_rx(Gateway, #link{devaddr=DevAddr}=Link, #rxdata{port=Port, data= RxData }, RxQ)->
	Data = RxData,
    	file:write_file("/tmp/foo.txt", io_lib:fwrite("~p.\n", [Data])),
	%POST request.
	inets:start(),
	ssl:start(),
    	httpc:request(post, {"http://localhost/apiv1/lorapacket/rx", [], "application/x-www-form-urlencoded", Data },[],[]),
	ok;
%Error handling
handle_rx(_Gateway, _Link, RxData, _RxQ) ->
{error, {unexpected_data, RxData}}.
