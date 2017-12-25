library jaguar.websocket;

import 'dart:io';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:jaguar/jaguar.dart';

/// Function prototype of a websocket handler
///
/// [socketHandler] function converts the [WebSocketHandler] into
/// [RouteFunc], so it can be directly added to [Jaguar] server.
///
/// TODO example
@experimental
typedef FutureOr<dynamic> WebSocketHandler(dynamic data, [WebSocket socket]);

@experimental
typedef FutureOr<dynamic> WebSocketHandlerSimple(dynamic data);

/// An utility function to upgrade Websocket request and also handle incoming
/// data.
///
/// [handler] is called on reception of data. The return value from [handler]
/// is written to the websocket.
///
/// TODO example
@experimental
RouteFunc socketHandler(WebSocketHandler handler,
    {void onConnect(Context ctx, WebSocket ws)}) {
  if (handler is WebSocketHandlerSimple) {
    return (Context ctx) async {
      final WebSocket websocket = await ctx.req.upgradeToWebSocket;
      websocket.listen((data) async {
        final resp = await handler(data);
        if (resp != null) websocket.add(resp);
      });
    };
  } else if (handler is WebSocketHandler) {
    return (Context ctx) async {
      final WebSocket websocket = await ctx.req.upgradeToWebSocket;
      websocket.listen((data) async {
        final resp = await handler(data, websocket);
        if (resp != null) websocket.add(resp);
      });
    };
  }

  throw new ArgumentError.value(handler, 'handler');
}
