library jaguar.websocket;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';

/// Function prototype of a websocket handler
///
/// [wsHandler] function converts the [WsHandlerWithWs] into
/// [RouteHandler], so it can be directly added to [Jaguar] server.
typedef FutureOr<dynamic> WsHandlerWithWs(dynamic data, [WebSocket socket]);

typedef FutureOr<dynamic> WsHandler(dynamic data);

/// [handler] is called on reception of data. The return value from [handler]
/// is written to the websocket.
///
/// [onConnect] is called when a websocket connection is established.
///
/// Example:
///     server.get('/ws', socketHandler((String data) => int.parse(data) + 1));
RouteHandler wsHandler(
    {WsHandler handler,
    FutureOr onConnect(Context ctx, WebSocket ws),
    WsResultProcessor resultProcessor}) {
  return (Context ctx) async {
    final WebSocket ws = await ctx.req.upgradeToWebSocket;
    ctx.response = SkipResponse();
    if (onConnect != null) await onConnect(ctx, ws);

    if (handler is WsHandler) {
      ws.listen((data) async {
        final resp = await handler(data);
        if (resp != null) {
          if (resp is List<int>) {
            ws.add(resp);
          } else if (resp is String) {
            ws.add(resp);
          } else if (resultProcessor != null) {
            ws.add(resultProcessor(resp));
          } else {
            ws.add(resp.toString());
          }
        }
      });
    } else if (handler is WsHandlerWithWs) {
      ws.listen((data) async {
        final resp = await handler(data, ws);
        if (resp != null) {
          if (resp is List<int>) {
            ws.add(resp);
          } else if (resp is String) {
            ws.add(resp);
          } else if (resultProcessor != null) {
            ws.add(resultProcessor(resp));
          } else {
            ws.add(resp.toString());
          }
        }
      });
    }
  };
}
