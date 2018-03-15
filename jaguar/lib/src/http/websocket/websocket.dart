library jaguar.websocket;

import 'dart:io';
import 'dart:async';
import 'package:jaguar/jaguar.dart';

/// Function prototype of a websocket handler
///
/// [socketHandler] function converts the [WsHandler] into
/// [RouteFunc], so it can be directly added to [Jaguar] server.
typedef FutureOr<dynamic> WsHandler(dynamic data, [WebSocket socket]);

typedef FutureOr<dynamic> WsTransformer(dynamic data);

/// Converts [WsHandler] to [RouteFunc]
///
/// [handler] is called on reception of data. The return value from [handler]
/// is written to the websocket.
///
/// If [responseProcessor] is provided, the data returned by [handler] is
/// processed before writing to the websocket.
///
/// [onConnect] is called when a websocket connection is established.
///
/// Example:
///     server.get('/ws', socketHandler((String data) => int.parse(data) + 1));
RouteFunc socketHandler(WsTransformer handler,
    {FutureOr onConnect(Context ctx, WebSocket ws),
    ResponseProcessor responseProcessor}) {
  if (handler is WsTransformer) {
    return (Context ctx) async {
      final WebSocket ws = await ctx.req.upgradeToWebSocket;
      if (onConnect != null) await onConnect(ctx, ws);
      if (responseProcessor == null) {
        ws.listen((data) async {
          final resp = await handler(data);
          if (resp != null)
            ws.add(
                resp is String || resp is List<int> ? resp : resp.toString());
        });
      } else {
        ws.listen((data) async {
          final resp = await handler(data);
          if (resp != null)
            ws.add(responseProcessor(
                resp is String || resp is List<int> ? resp : resp.toString()));
        });
      }
    };
  } else if (handler is WsHandler) {
    return (Context ctx) async {
      final WebSocket ws = await ctx.req.upgradeToWebSocket;
      if (onConnect != null) await onConnect(ctx, ws);
      if (responseProcessor == null) {
        ws.listen((data) async {
          final resp = await handler(data, ws);
          if (resp != null)
            ws.add(
                resp is String || resp is List<int> ? resp : resp.toString());
        });
      } else {
        ws.listen((data) async {
          final resp = await handler(data, ws);
          if (resp != null)
            ws.add(responseProcessor(
                resp is String || resp is List<int> ? resp : resp.toString()));
        });
      }
    };
  }

  throw new ArgumentError.value(handler, 'handler');
}
