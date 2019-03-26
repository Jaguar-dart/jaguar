part of 'websocket.dart';

/// Data read from [stream] is sent to the websocket.
///
/// [onConnect] is called when a websocket connection is established.
RouteHandler wsStream<T>(WsOnConnect /* < Stream<T> | Response > */ onConnect) {
  return (Context ctx) async {
    final WebSocket ws = await ctx.req.upgradeToWebSocket;
    ctx.response = SkipResponse();
    Stream<T> stream;
    if (onConnect != null) {
      final resp = await onConnect(ctx, ws);
      if (resp is Response) {
        ctx.response = resp;
        return;
      } else if (resp is Stream<T>) {
        stream = resp;
      } else {
        throw UnsupportedError("Unsupported type!");
      }
    }

    StreamSubscription sub;

    if (T == String) {
      sub = stream.listen((T t) {
        ws.add(t);
      }, onDone: () async {
        await sub.cancel();
      }, onError: (_) async {
        await sub.cancel();
      }, cancelOnError: true);
    } else if (T == Iterable) {
      sub = stream.listen((T t) {
        ws.add(t);
      }, onDone: () async {
        await sub.cancel();
      }, onError: (_) async {
        await sub.cancel();
      }, cancelOnError: true);
    } else {
      sub = stream.listen((T t) {
        if (t != null) ws.add(t.toString());
      }, onDone: () async {
        await sub.cancel();
      }, onError: (_) async {
        await sub.cancel();
      }, cancelOnError: true);
    }

    sub.onDone(() async {
      await ws.close();
    });
    sub.onError((_) async {
      await ws.close();
    });
  };
}
