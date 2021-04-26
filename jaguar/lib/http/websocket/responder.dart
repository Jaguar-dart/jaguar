part of 'websocket.dart';

typedef WsResponder = FutureOr<dynamic> Function(dynamic data);

RouteHandler wsRespond<T>(
    WsOnConnect /* < WsResponder | Response > */ onConnect,
    {final Encoding? encoding}) {
  return (Context ctx) async {
    final WebSocket ws = await ctx.req.upgradeToWebSocket;
    ctx.response = SkipResponse();
    WsResponder responder;
    final resp = await onConnect(ctx, ws);
    if (resp is Response) {
      ctx.response = resp;
      return;
    } else if (resp is WsResponder) {
      responder = resp;
    } else {
      throw UnsupportedError("Unsupported type!");
    }

    ws.listen((d) {
      // Convert incoming data to string
      String str = '';
      if (d is String) {
        str = d;
      } else if (d is List<int>) {
        if (encoding == null) {
          throw Exception('encoding is required');
        }
        str = encoding.decode(d);
      }

      // JSON decode
      final js = json.decode(str);
      if (js is! Map) return;
      dynamic id = js['id'];
      try {
        final resp = responder(js['content']);
        ws.add(json.encode({
          'id': id,
          'content': resp,
        }));
      } catch (_) {}
    }, cancelOnError: true);
  };
}
